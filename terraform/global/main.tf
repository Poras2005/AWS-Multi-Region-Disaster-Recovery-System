terraform {
  backend "s3" {
    key            = "global/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "ap-south-1"
}

variable "domain" {}
variable "primary_alb_dns" {}
variable "secondary_alb_dns" {}
variable "health_check_path" {}
variable "failover_ttl" {}
variable "app_name" {}

# Route 53
resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_health_check" "primary" {
  fqdn              = var.primary_alb_dns
  port              = 80
  type              = "HTTP"
  resource_path     = var.health_check_path
  failure_threshold = "3"
  request_interval  = "10"
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "CNAME"
  ttl     = var.failover_ttl

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "primary"
  records        = [var.primary_alb_dns]
  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "CNAME"
  ttl     = var.failover_ttl

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary"
  records        = [var.secondary_alb_dns]
}

# ECR (Though Phase 2 creates it, we define it here for IaC completeness if needed)
# However, deploy.py creates it via boto3. We'll leave it as a comment or data source.
# data "aws_ecr_repository" "app" { name = var.app_name }

# WAF - Basic regional WAF (Simplified)
resource "aws_wafv2_web_acl" "main" {
  name        = "${var.app_name}-waf"
  description = "Basic WAF for ${var.app_name}"
  scope       = "REGIONAL"
  default_action { allow {} }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.app_name}-waf-metric"
    sampled_requests_enabled   = true
  }
}
