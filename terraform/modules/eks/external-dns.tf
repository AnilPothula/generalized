resource "aws_iam_role" "eks_dns_role" {
  name               = "terraform_${var.environment}_${var.cluster_name}_eks_dns_role"
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

# adding the necessary policies for external-dns
# @see https://github.com/kubernetes-incubator/external-dns/blob/master/docs/tutorials/aws.md

resource "aws_iam_role_policy" "eks_dns_policy" {
  depends_on = [aws_iam_role.eks_dns_role]
  name       = "terraform_${var.environment}_${var.cluster_name}_eks_dns_policy"
  role       = aws_iam_role.eks_dns_role.name
  policy     = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "route53:ChangeResourceRecordSets"
     ],
     "Resource": [
       "arn:aws:route53:::hostedzone/*"
     ]
   },
   {
     "Effect": "Allow",
     "Action": [
       "route53:ListHostedZones",
       "route53:ListResourceRecordSets",
       "elasticloadbalancing:DescribeLoadBalancers",
       "sts:AssumeRole"
     ],
     "Resource": [
       "*"
     ]
   }
 ]
}
EOF

}

data "template_file" "external_dns_public" {
  template = file("${path.module}/templates/external-dns.yaml.tpl")
  vars = {
    cluster_name         = "${aws_eks_cluster.k8s.name}-public"
    domain_name          = var.public_domain_name
    dns_role             = aws_iam_role.eks_dns_role.arn
    zone_type            = "public"
    policy               = "sync"
    pod_name             = "external-dns-public"
    external_dns_version = var.external_dns_version
  }
}

resource "local_file" "external_dns_public" {
  count      = var.render_files ? 1 : 0
  content    = data.template_file.external_dns_public.rendered
  filename   = "dist/external_dns_public_${aws_eks_cluster.k8s.name}.yaml"
  depends_on = [null_resource.clean_dist]
}

data "template_file" "external_dns_private" {
  template = file("${path.module}/templates/external-dns.yaml.tpl")
  vars = {
    cluster_name         = "${aws_eks_cluster.k8s.name}-private"
    domain_name          = var.private_domain_name
    dns_role             = aws_iam_role.eks_dns_role.arn
    zone_type            = "private"
    policy               = "sync"
    pod_name             = "external-dns-private"
    external_dns_version = var.external_dns_version
  }
}

resource "local_file" "external_dns_private" {
  count      = var.private_domain_name != "" && var.render_files ? 1 : 0
  content    = data.template_file.external_dns_private.rendered
  filename   = "dist/external_dns_private_${aws_eks_cluster.k8s.name}.yaml"
  depends_on = [null_resource.clean_dist]
}

