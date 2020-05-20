output "eks_api_endpoint" {
  value = module.eks.endpoint
}

output "eks_cluster_arn" {
  value = module.eks.arn
}

output "eks_cluster_id" {
  value = module.eks.id
}