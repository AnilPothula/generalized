#
# Rendering efs-storage-class template
#
data "template_file" "efs_storage_classes" {
  count    = var.deploy_efs ? 1 : 0
  template = file("${path.module}/templates/efs-storage-classes.yaml.tpl")

  vars = {
    efs_id                  = aws_efs_file_system.efs[0].id
    efs_region              = data.aws_region.current.name
    cluster_name            = var.cluster_name
    efs_namespace           = var.efs_namespace
    efs_dns_name            = aws_efs_file_system.efs[0].dns_name
    efs_provisioner_version = var.efs_provisioner_version
  }
}

resource "local_file" "efs_storage_classes" {
  count      = var.render_files && var.deploy_efs ? 1 : 0
  content    = data.template_file.efs_storage_classes[0].rendered
  filename   = "dist/efs-storage-classes.yaml"
  depends_on = [null_resource.clean_dist]
}

#
# AWS EFS setup
#

resource "aws_efs_file_system" "efs" {
  count          = var.deploy_efs ? 1 : 0
  creation_token = "${var.environment}_${var.cluster_name}"
  encrypted      = true
  tags = {
    Name       = "${var.environment}_${var.cluster_name}"
    BackupPlan = "daily"
  }
  lifecycle {
    ignore_changes = [creation_token]
  }
}

resource "aws_efs_mount_target" "efs" {
  count           = var.deploy_efs ? var.private_subnets_count : 0
  file_system_id  = aws_efs_file_system.efs[0].id
  subnet_id       = element(var.private_subnets, count.index)
  security_groups = [aws_security_group.efs[0].id]
}

resource "aws_security_group" "efs" {
  count       = var.deploy_efs ? 1 : 0
  name        = "${var.environment}-${var.cluster_name}-efs"
  description = "EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = "2049" # NFS
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

