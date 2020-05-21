locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.identifier}-${terraform.workspace}"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  force_detach_policies  = true
  description            = var.description
  name                   = "${var.identifier}-${terraform.workspace}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "${var.aws_service_principal}"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  count      = length(var.iam_policies_to_attach)

  policy_arn = element(var.iam_policies_to_attach, count.index)
  role       = aws_iam_role.role.name
}