locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  
  tags = merge(local.default_tags, var.tags)
}

resource "aws_elasticache_subnet_group" "default" {
  subnet_ids  = var.public_subnets_ids
  name         = "${var.identifier}-${terraform.workspace}"
}

resource "aws_elasticache_cluster" "redis" {
  parameter_group_name = var.parameter_group_name
  maintenance_window   = var.maintenance_window
  security_group_ids   = var.sg_redis
  subnet_group_name    = aws_elasticache_subnet_group.default.name
  num_cache_nodes      = var.num_cache_nodes
  engine_version       = var.elasticache_engine_version
  cluster_id           = "${var.identifier}-${terraform.workspace}"
  node_type            = var.elasticache_instance_type
  engine               = var.elasticache_engine
  port                 = var.port

  tags                 = local.tags
}