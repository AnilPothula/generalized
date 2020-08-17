variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "max_vcpus" {
  description = "Max VCPUs"
  type        = number
}

variable "desired_vcpus" {
  description = "Desired VCPUs"
  type        = number
}

variable "min_vcpus" {
  description = "Min VCPUs"
  type        = number
}

variable "ec2_key_pair" {
  description = "EC2 Key pair"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "subnets" {
  description = "subnets"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}

variable "image" {
  description = "Docker image to be used"
  type        = string
}