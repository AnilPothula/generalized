variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "compute_environment_arn" {
  description = "Compute Environment ARN"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}
