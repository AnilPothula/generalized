#
# Allow worker nodes to register into the cluster
#

data "template_file" "configmap" {
  template = file("${path.module}/templates/aws-configmap.yaml.tpl")
  vars = {
    eks_worker_role = aws_iam_role.eks_worker_role.arn
    eks_access_role = aws_iam_role.eks-access-role.arn
  }
}

resource "local_file" "configmap" {
  count      = var.render_files ? 1 : 0
  content    = data.template_file.configmap.rendered
  filename   = "dist/1.aws_configmap_${aws_eks_cluster.k8s.name}.yaml"
  depends_on = [null_resource.clean_dist]
}

#
# Role to be able to access EKS with kubectl
#
resource "aws_iam_role" "eks-access-role" {
  name               = "terraform_${var.environment}_${var.cluster_name}_eks_admin_access_role"
  description        = "Assume this role to be able to perform kubectl commands in to the eks cluster"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": { "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
    "Action": "sts:AssumeRole"
  }
}
POLICY

}

resource "aws_iam_role_policy" "eks-readonly-policy" {
  depends_on = [aws_iam_role.eks-access-role]
  name       = "terraform_${var.environment}_${var.cluster_name}_eks_readonly_policy"
  role       = aws_iam_role.eks-access-role.name
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster"
            ],
            "Resource": "${aws_eks_cluster.k8s.arn}"
        }
    ]
}
EOF

}

