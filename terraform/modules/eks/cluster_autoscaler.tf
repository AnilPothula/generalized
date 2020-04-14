# @see https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/
resource "aws_iam_role" "eks-autoscaler-role" {
  name               = "terraform_${var.environment}_${var.cluster_name}_eks_autoscaler_role"
  depends_on         = [aws_iam_role.eks_worker_role]
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.eks_worker_role.arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

#
# Set cluster autoscaller necessary policies
#
resource "aws_iam_role_policy" "eks-autoscaler-policy" {
  depends_on = [aws_iam_role.eks-autoscaler-role]
  name       = "terraform_${var.environment}_${var.cluster_name}_eks_autoscaler_policy"
  role       = aws_iam_role.eks-autoscaler-role.name
  policy     = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF

}

data "template_file" "cluster_autoscaler" {
  template = file("${path.module}/templates/cluster_autoscaler.yaml.tpl")
  vars = {
    cluster_name       = aws_eks_cluster.k8s.name
    autoscaler_role    = aws_iam_role.eks-autoscaler-role.arn
    autoscaler_version = var.autoscaler_version
    region             = data.aws_region.current.name
  }
}

resource "local_file" "cluster_autoscaler" {
  count      = var.render_files ? 1 : 0
  content    = data.template_file.cluster_autoscaler.rendered
  filename   = "dist/cluster_autoscaler_${aws_eks_cluster.k8s.name}.yaml"
  depends_on = [null_resource.clean_dist]
}

