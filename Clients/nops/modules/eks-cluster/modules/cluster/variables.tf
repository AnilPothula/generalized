variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "eks_version" {
  description = "Desired Kubernetes master version"
  default     = "1.15"
  type        = string
}

variable "eks_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS API server is public"
  default     = true
  type        = bool
}

variable "public_access_cidrs" {
  description = "Indicates which CIDR blocks can access the Amazon EKS API server endpoint"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to allow communication between your worker nodes and the Kubernetes control plane"
  default     = []
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}