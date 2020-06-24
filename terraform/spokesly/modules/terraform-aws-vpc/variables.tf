variable "cidr" {
  default = "10.0.0.0/16"
}

variable "name" {
  default = "Terraform"
}

variable "nat_per_az" {
  default = false
}

variable "subnet_outer_offsets" {
  type        = list(number)
  default     = [ 1, 1 ]
}

variable "subnet_inner_offsets" {
  type        = list(number)
  default     = [ 1, 1 ]
}

locals {
  nat_count = var.nat_per_az ? length(local.subnet_list[0]) : 1
}

variable "allow_cidrs_default" {
  type    = map(string)
  default = {}
}

variable "separate_db_subnets" {
  type    = bool
  default = false
}

variable "transit_gateway_attach" {
  default = false
}

variable "transit_gateway_id" {
  default = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  default     = {}
}

variable "skip_az" {
  description = "Skip the first AZ in the us-east-1 region, since t3 and m5 was not available. Still present for backward compatibility"
  default = 0
}
