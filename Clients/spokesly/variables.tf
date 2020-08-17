variable "identifier" {
  description = "The name for the cluster"
  default     = "spokesly"
  type        = string
}

variable "desired_vcpus" {
  description = "Desired VCPUs"
  default     = 2
  type        = number
}

variable "max_vcpus" {
  description = "Max VCPUs"
  default     = 4
  type        = number
}

variable "min_vcpus" {
  description = "Min VCPUs"
  default     = 0
  type        = number
}

variable "ec2_key_pair" {
  description = "EC2 Key pair"
  default     = "parveen-oregon"
  type        = string
}

variable "subnets" {
  description = "subnets"
  default     = "subnet-982c19c2,subnet-ee9adea5,subnet-03942228,subnet-d50b51ac"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  default     = "vpc-20de1758"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}

variable "image" {
  description = "Docker image to be used"
  default     = "695292474035.dkr.ecr.us-west-2.amazonaws.com/spokesly"
  type        = string
}
