locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_elasticache_subnet_group" "main" {
    description = var.subnet_group_description
    subnet_ids  = var.subnets
    name        = "${var.identifier}-${terraform.workspace}"
}

resource "aws_elasticache_cluster" "default" {
  subnet_group_name    = aws_elasticache_subnet_group.main.id
  cluster_id           = var.cluster_id
  node_type            = var.node_type
  engine               = var.engine
  num_cache_nodes      = var.num_cache_nodes
  security_group_ids   = [var.security_group_id]
  tags                 = local.tags
}
