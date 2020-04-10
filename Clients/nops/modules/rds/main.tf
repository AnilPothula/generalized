locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_db_subnet_group" "main" {
    description = var.subnet_group_description
    subnet_ids  = var.subnets
    name        = "${var.identifier}-${terraform.workspace}"
    tags        = local.tags
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "aws_ssm_parameter" "secret" {
  description = var.ssm_db_password_key_description
  value       = random_password.password.result
  name        = "/${var.identifier}-${terraform.workspace}/database/${var.rds_master_username}"
  type        = "SecureString"
  tags        = local.tags
}

resource "aws_db_instance" "default" {
    identifier                  = "${var.identifier}-${terraform.workspace}"
    allocated_storage           = var.rds_allocated_storage
    engine                      = var.engine
    engine_version              = var.engine_version
    instance_class              = var.instance_class
    db_subnet_group_name        = aws_db_subnet_group.main.id
    name                        = var.database_name
    username                    = var.rds_master_username
    password                    = random_password.password.result
    multi_az                    = var.multi_az
    vpc_security_group_ids      = [var.security_group_id]
    tags                        = local.tags
}

