output "endpoint" {
  value = aws_eks_cluster.control_plane.endpoint
}

output "kubeconfig_certificate_authority_data" {
  value = aws_eks_cluster.control_plane.certificate_authority.0.data
}

output "cluster_security_group" {
  value = aws_eks_cluster.control_plane.vpc_config.0.cluster_security_group_id
}

output "id" {
  value = aws_eks_cluster.control_plane.id
}

output "arn" {
  value = aws_eks_cluster.control_plane.id
}

output "role_arn" {
  value = aws_iam_role.role.arn
}