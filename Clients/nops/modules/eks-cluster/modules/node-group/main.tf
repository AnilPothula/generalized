locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)

  eks = var.eks_cluster_id != "" ? [1] : []
}

resource "aws_launch_configuration" "launch_config" {
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = var.iam_instance_profile
  user_data_base64            = var.user_data_base64
  security_groups             = var.security_groups
  ebs_optimized               = var.ebs_optimized
  instance_type               = var.instance_type
  name_prefix                 = "${var.identifier}-${terraform.workspace}-"
  image_id                    = var.image_id
  key_name                    = var.key_name

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
    encrypted   = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.launch_config.id
  vpc_zone_identifier  = var.subnets
  desired_capacity     = var.min_size
  name_prefix          = "${var.identifier}-${terraform.workspace}-"
  max_size             = var.max_size
  min_size             = var.min_size

  depends_on           = [aws_launch_configuration.launch_config]

  lifecycle {
    ignore_changes     = [desired_capacity]
  }

  dynamic "tag" {
    for_each = local.tags
    content {
      propagate_at_launch = true
      value               = tag.value
      key                 = tag.key
    }
  }

  dynamic "tag" {
    for_each = local.eks
    content {
      propagate_at_launch = true
      value               = "owned"
      key                 = "kubernetes.io/cluster/${var.eks_cluster_id}"
    }
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  estimated_instance_warmup = var.estimated_instance_warmup
  metric_aggregation_type   = var.metric_aggregation_type
  autoscaling_group_name    = "${aws_autoscaling_group.asg.name}"
  adjustment_type           = var.adjustment_type
  policy_type               = var.policy_type
  name                      = "scale-up-policy-${var.identifier}"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
    }
}

resource "aws_autoscaling_policy" "scale_down" {
  estimated_instance_warmup = var.estimated_instance_warmup
  metric_aggregation_type   = var.metric_aggregation_type
  autoscaling_group_name    = "${aws_autoscaling_group.asg.name}"
  adjustment_type           = var.adjustment_type
  policy_type               = var.policy_type
  name                      = "scale-down-policy-${var.identifier}"

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
    }
}