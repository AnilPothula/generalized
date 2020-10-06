locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.identifier}-${terraform.workspace}-ecs_instance_role"
  path = "/Batch/"
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
  path = "/Batch/"
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_batch_compute_environment" "compute_environment" {
  compute_environment_name = "${var.identifier}-${terraform.workspace}"

  compute_resources {
    instance_role = "${aws_iam_instance_profile.ecs_instance_role.arn}"
    instance_type = ["optimal"]
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

## Batch Jon QUEUE

resource "aws_batch_job_queue" "batch-queue" {
  name = "${var.identifier}-${terraform.workspace}-queue" 
  state = "ENABLED"
  priority = 1
  compute_environments = [ 
    "${aws_batch_compute_environment.compute_environment.arn}"
  ]
}

## Batch Job started
resource "aws_iam_role" "job-role" {
  name = "${var.identifier}-${terraform.workspace}-job-role"
  path = "/Batch/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
      {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          }
      }
    ]
}
EOF
}



resource "aws_iam_policy" "job-policy" {
  name = "${var.identifier}-${terraform.workspace}-job-policy"
  path = "/Batch/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "job-role" {
  role = "${aws_iam_role.job-role.name}"
  policy_arn = "${aws_iam_policy.job-policy.arn}"
}

resource "aws_batch_job_definition" "test" {
  name = "${var.identifier}-${terraform.workspace}-job_definition"
  type = "container"

  container_properties = <<CONTAINER_PROPERTIES
{
    "image": "${var.image}",
    "jobRoleArn": "${aws_iam_role.job-role.arn}",
    "memory": 1024,
    "vcpus": 1,
    "volumes": [
      {
        "host": {
          "sourcePath": "/tmp"
        },
        "name": "tmp"
      }
    ],
    "environment": [
        {"name": "VARNAME", "value": "VARVAL"}
    ],
    "mountPoints": [
        {
          "sourceVolume": "tmp",
          "containerPath": "/tmp",
          "readOnly": false
        }
    ],
    "ulimits": [
      {
        "hardLimit": 1024,
        "name": "nofile",
        "softLimit": 1024
      }
    ]
}
CONTAINER_PROPERTIES
}
