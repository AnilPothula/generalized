variable "vpc_id" {
  description = "Define ID of the VPC where cluster is to be created"
  type        = string
}

variable "public_subnets_ids" {
  description = "List of subnets for the resource network scope"
  type        = list
}

variable "elasticache_engine_version" {
  description = "Define the Elasticache Redis engine version"
  default     = "4.0.10"
  type        = string
}

variable "elasticache_engine" {
  description = "Define the Elasticache engine to be used"
  default     = "redis"
  type        = string
}

variable "parameter_group_name" {
  description = "Parameter Group for the redis cluster"
  default     = "default.redis4.0"
  type        = string
}

variable "elasticache_instance_type" {
  description = "Define the instance size"
  default     = "cache.t2.small"
  type        = string
}

variable "maintenance_window" {
  description = "Define the Maintenance Window"
  default     = "wed:13:00-wed:14:00"
  type        = string
}

variable "port" {
  description = "Define the port to be used for Elasticache Redis"
  default     = 6379
  type        = number
}

variable "identifier" {
  description = "Define an identifier/name for the cluster"
  type        = string
}

variable "num_cache_nodes" {
  description = "Number of cache nodes needed"
  default     = 1
  type        = number
}

variable "sg_redis" {
  description = "security group for redis"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}