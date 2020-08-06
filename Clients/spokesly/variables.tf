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
  default     = "shariq-oregonkey"
  type        = string
}

variable "subnets" {
  description = "subnets"
  default     = "subnet-09fcc09f970177ac5,subnet-0f8ff3b4a2e20bf95"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  default     = "vpc-0c570d6807bb402d7"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}
