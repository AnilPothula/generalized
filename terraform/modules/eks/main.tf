# this will create K8s cluster master and will also create
# all the necessary IAM roles required by K8s master nodes

# create an IAM role that will be used by the K8s master
data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

resource "aws_iam_role" "eks_master_role" {
  name               = "eks_master_role_k8s_${var.environment}_${var.cluster_name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

# lets attach all the policies that K8s master nodes needs to manage all aws resources
resource "aws_iam_role_policy_attachment" "eks-ClusterPolicies" {
  count      = length(var.cluster_policies)
  policy_arn = "arn:aws:iam::aws:policy/${var.cluster_policies[count.index]}"
  role       = aws_iam_role.eks_master_role.name
}

# security group for the master nodes
resource "aws_security_group" "k8s_master_security_group" {
  name        = "k8s_master_sg_${var.environment}_${var.cluster_name}"
  description = "Allows K8s Master communication to the worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = var.environment
    k8s-cluster = "${var.environment}_${var.cluster_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "k8s_worker_ingress_master" {
  description              = "Allow worker Kubelets and pods to receive communication from the master control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k8s_worker_security_group.id
  source_security_group_id = aws_security_group.k8s_master_security_group.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "k8s-master-ingress-worker" {
  description              = "Allow workers to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k8s_master_security_group.id
  source_security_group_id = aws_security_group.k8s_worker_security_group.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "k8s-worker-ingress-ControlPlane" {
  description              = "Allow workers to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.k8s_worker_security_group.id
  source_security_group_id = aws_security_group.k8s_master_security_group.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_eks_cluster" "k8s" {
  name     = "${var.environment}_${var.cluster_name}"
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.k8s_version
  vpc_config {
    security_group_ids = [aws_security_group.k8s_master_security_group.id]
    subnet_ids         = concat(var.public_subnets, var.private_subnets)
  }
  depends_on = [
    aws_iam_role.eks_master_role,
    aws_security_group.k8s_master_security_group,
    aws_iam_role_policy_attachment.eks-ClusterPolicies,
  ]
}

#
# dist is the folder where the templates are being rendered, we need to
# clean up before adding new templates on every apply
#
resource "null_resource" "clean_dist" {
  count = var.render_files ? 1 : 0
  provisioner "local-exec" {
    command = "rm -R dist/ || ls"
  }
  triggers = {
    build_number = timestamp()
  }
}

