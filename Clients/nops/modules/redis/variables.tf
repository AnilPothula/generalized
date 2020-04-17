variable "cluster_id" {
  description = "Cluster id for the resources"
  default     = ""
  type        = string
}

variable "node_type" {
  description = "Node Type"
  default     = ""
  type        = string
}

variable "engine" {
  description = "Engine"
  default     = ""
  type        = string
}


variable "num_cache_nodes" {
  description = "Cache Nodes"
  default     = 1
  type        = number
}

variable "security_group_id" {
  description = "Security group"
  default     = ""
  type        = string
}


variable "subnets" {
  description = "A list of VPC subnet IDs"
  default     = []
  type        = list(string)
}

variable "identifier" {
  description = "The name for the resources"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}

variable "subnet_group_description" {
  description = "Subnet Group Description"
  default     = "RDS Subnet Group"
  type        = string
}