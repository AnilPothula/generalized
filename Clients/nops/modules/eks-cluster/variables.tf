variable "region" {
  description = "The region where the resources will be deployed"
  default     = "us-west-2"
  type        = string
}

variable "identifier" {
  description = "ID for all resources"
  default     = "nops-test"
  type        = string
}

variable "iam_policies_to_attach" {
  description = "List of ARNs of IAM policies to attach"
  default     = [
                  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
                  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
                  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
                ]
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones where subnets will be deployed"
  default     = ["us-west-2a","us-west-2b"]
  type        = list(string)
}

variable "cidr" {
  description = "Range of IPv4 addresses for your VPC in CIDR block format"
  default     = "172.16.0.0/16"
  type        = string
}

variable "eks_version" {
  description = "eks version to use"
  default     = "1.15"
  type        = string
}

variable "ken_instance_type" {
  description = "Instance type to use"
  default     = "t3.medium"
  type        = string
}

variable "celery_instance_type" {
  description = "Instance type to use"
  default     = "t3.medium"
  type        = string
}

variable "key_name" {
  description = "Keypair to use"
  default     = "nclouds-tf"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {
    Owner     = "example@nclouds.com"
  }
  type        = map
}

variable "vpc_id" {
  description = "VPC where are created all the resources"
  default     = "vpc-xxxxxxxxxxxx"
  type        = string
}

variable "private_subnets_ids" {
  description = "List of all the private subnets"
  default     = ["subnet-xxxxxxxxxxxxxxxxxx"]
  type        = list(string)
}

variable "public_subnets_ids" {
  description = "List of all the public subnets"
  default     = ["subnet-xxxxxxxxxxxxxxxxxx"]
  type        = list(string) 
}

