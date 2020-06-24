resource "aws_iam_role" "main" {
  name_prefix = "opsworks.${var.name}."

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [{
    "Sid": "",
    "Effect": "Allow",
    "Principal": {
      "Service": "opsworks.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }]
}
EOF
}

resource "aws_iam_policy" "main" {
  name_prefix = "opsworks.${var.name}."
  description = "AWS OpsWorks Service Role Policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": [
      "ec2:*",
      "iam:GetRolePolicy",
      "iam:ListInstanceProfiles",
      "iam:ListRoles",
      "iam:ListUsers",
      "iam:PassRole",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:DescribeAlarms",
      "ecs:*",
      "elasticloadbalancing:*",
      "rds:*"
    ],
    "Effect": "Allow",
    "Resource": [ "*" ]
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.id
  policy_arn = aws_iam_policy.main.arn
}

resource "aws_iam_role" "ec2" {
  name_prefix = "ec2.${var.name}."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }]
}
EOF
}

resource "aws_iam_instance_profile" "ec2" {
  name_prefix = "ec2.${var.name}."
  path        = "/"
  role        = aws_iam_role.ec2.name
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch" {
  role       = aws_iam_role.ec2.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
