locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_elasticsearch_domain" "es_domain" {
    elasticsearch_version = var.elasticsearch_version
    domain_name           = "${var.identifier}"
    access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY

    advanced_options = {
      "rest.action.multi.allow_explicit_index" = true
    }

    ebs_options {
      ebs_enabled = var.ebs_enabled
      volume_type = var.volume_type
      volume_size = var.volume_size
      iops        = var.iops
    }

    cluster_config {
      dedicated_master_enabled = var.dedicated_master_enabled
      dedicated_master_count   = var.dedicated_master_count
      zone_awareness_enabled   = var.zone_awareness_enabled
      dedicated_master_type    = var.dedicated_master_type
      instance_count           = var.instance_count
      instance_type            = var.instance_type
    }

    snapshot_options {
      automated_snapshot_start_hour = var.automated_snapshot_start_hour
    }

    # vpc_options {
    #   security_group_ids = var.security_group_ids
    #   subnet_ids         = var.subnets_ids
    # }

    tags  = local.tags
}




