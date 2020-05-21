locals {

  ##Userdata for ken and celery nodes
  worker_node_userdata = <<USERDATA

USERDATA
}

data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${var.eks_version}/amazon-linux-2/recommended/image_id"
}

module "role" {
  source = "./modules/iam-role "
  iam_policies_to_attach = var.iam_policies_to_attach
  aws_service_principal  = "ec2.amazonaws.com"
  identifier             = "${var.identifier}-eks-role"
  tags                   = var.tags
} 

module "eks" {
  source = "./modules/cluster"
  security_group_ids     = [module.eks_security_group.group_id]
  identifier             = var.identifier
  subnet_ids             = concat(var.private_subnets_ids,var.public_subnets_ids)
  tags                   = var.tags
}

module "eks_security_group" {
  source     = "./modules/security-group"
  identifier = "${var.identifier}-eks"
  vpc_id     = var.vpc_id
  tags       = var.tags
}

module "ken_node_group" {
  source = "./modules/node-group"
  iam_instance_profile = module.role.profile_arn
  user_data_base64     = base64encode(local.worker_node_userdata)
  security_groups      = [module.eks_security_group.group_id]
  eks_cluster_id       = module.eks.id
  instance_type        = var.ken_instance_type
  identifier           = var.identifier
  image_id             = data.aws_ssm_parameter.eks_ami.value
  key_name             = var.key_name
  subnets              = var.private_subnets_ids
  tags                 = var.tags
}

module "celery_node_group" {
  source = "./modules/node-group"
  iam_instance_profile = module.role.profile_arn
  user_data_base64     = base64encode(local.worker_node_userdata)
  security_groups      = [module.eks_security_group.group_id]
  eks_cluster_id       = module.eks.id
  instance_type        = var.celery_instance_type
  identifier           = var.identifier
  image_id             = data.aws_ssm_parameter.eks_ami.value
  key_name             = var.key_name
  subnets              = var.private_subnets_ids
  tags                 = var.tags
}