output "eks_worker_role_arn" {
  value = aws_iam_role.eks_worker_role.arn
}

output "eks_access_role" {
  value = aws_iam_role.eks-access-role.arn
}

