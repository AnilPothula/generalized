locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_iam_role" "role" {
  force_detach_policies  = true
  description            = "Created by terraform for EKS Control Plane"
  name                   = "${var.identifier}-${terraform.workspace}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.role.name
}

resource "aws_eks_cluster" "control_plane" {
  role_arn = aws_iam_role.role.arn
  version  = var.eks_version
  name     = "${var.identifier}-${terraform.workspace}"

  vpc_config {
    endpoint_private_access = var.eks_endpoint_public_access
    endpoint_public_access  = var.eks_endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = var.security_group_ids
    subnet_ids              = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_iam_role_policy_attachment.service,
  ]

  tags        = local.tags
}