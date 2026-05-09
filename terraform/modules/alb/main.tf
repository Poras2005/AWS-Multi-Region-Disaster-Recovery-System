variable "vpc_id" { type = string }
variable "public_subnets" { type = list(string) }
variable "app_name" { type = string }
variable "region" { type = string }

resource "aws_security_group" "alb" {
  name        = "${var.app_name}-alb-sg-${var.region}"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main" {
  name               = "${var.app_name}-alb-${var.region}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "app" {
  name     = "${var.app_name}-tg-${var.region}"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/health"
    port = "5000"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

output "target_group_arn" { value = aws_lb_target_group.app.arn }
output "dns_name" { value = aws_lb.main.dns_name }
output "zone_id" { value = aws_lb.main.zone_id }
output "security_group_id" { value = aws_security_group.alb.id }
