variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "ec2_sg_id" { type = string }
variable "app_name" { type = string }
variable "region" { type = string }
variable "multi_az" { default = false }
variable "replicate_source_db" { default = null }

variable "db_name" { default = "drappdb" }
variable "db_password" { type = string }

resource "aws_secretsmanager_secret" "db_pass" {
  name        = "${var.app_name}-db-pass-${var.region}"
  description = "Database password for ${var.app_name} in ${var.region}"
  recovery_window_in_days = 0 # Force delete for demo
}

resource "aws_secretsmanager_secret_version" "db_pass" {
  secret_id     = aws_secretsmanager_secret.db_pass.id
  secret_string = var.db_password
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.app_name}-db-subnet-${var.region}"
  subnet_ids = var.private_subnets
  tags       = { Name = "${var.app_name}-db-subnet" }
}

resource "aws_security_group" "rds" {
  name        = "${var.app_name}-rds-sg-${var.region}"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_sg_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "main" {
  identifier           = "${var.app_name}-db-${var.region}"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = var.replicate_source_db == null ? var.db_name : null
  username             = var.replicate_source_db == null ? "admin" : null
  password             = var.replicate_source_db == null ? var.db_password : null
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  multi_az             = var.multi_az
  backup_retention_period = var.replicate_source_db == null ? 7 : 0
  
  replicate_source_db = var.replicate_source_db
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
}

output "db_instance_arn" { value = aws_db_instance.main.arn }
output "db_instance_id" { value = aws_db_instance.main.id }
output "secret_arn" { value = aws_secretsmanager_secret.db_pass.arn }
