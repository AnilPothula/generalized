locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.identifier}-${terraform.workspace}-ecs_instance_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name = "${var.identifier}-${terraform.workspace}-ecs_instance_role"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_iam_role" "aws_batch_service_role" {
  name = "${var.identifier}-${terraform.workspace}-aws_batch_service_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = "${aws_iam_role.aws_batch_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_security_group" "batch" {
  name = "${var.identifier}-${terraform.workspace}-sg"
  vpc_id      = "${var.vpc_id}"
  tags = local.tags

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "22"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_batch_compute_environment" "compute_environment" {
  compute_environment_name = "${var.identifier}-${terraform.workspace}"

  compute_resources {
    instance_role = "${aws_iam_instance_profile.ecs_instance_role.arn}"
    
    instance_type = ["c5"]

    max_vcpus = "${var.max_vcpus}"
    desired_vcpus = "${var.desired_vcpus}"
    min_vcpus = "${var.min_vcpus}"
    ec2_key_pair = "${var.ec2_key_pair}"

    security_group_ids = [
      aws_security_group.batch.id,
    ]

    subnets = [
       "${var.subnets}",
    ]

    type = "EC2"
    allocation_strategy = "BEST_FIT"
    tags = local.tags
  }

  service_role = "${aws_iam_role.aws_batch_service_role.arn}"
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]
}
