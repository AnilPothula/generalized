variable "profile" {
  default  = "nclouds"
}

variable "region" {
  default = "us-east-1"
}

variable "name" {
  default = "elasticsearch"
}

# variable "vpc_cidr" {
#   default = "10.255.0.0/16"
# }

variable "tags" {
  type    = map
  default = {}
}

variable "master_instance" {
  default = {
    type  = "t2.small"
    count = 1
  }
}

variable "data_instance" {
  default = {
    type  = "t2.small"
    count = 1
  }
}

variable "vpc_id" {
  default = "vpc-0590caf97afb07576"
}
variable "vpc_cidr" {
  default = "172.16.0.0/16"
}
variable "private_subnets" {
  default = ["subnet-0e93661af6af39701","subnet-07ebf08ea9fa87bad", "subnet-02b85b047beb36e49"]
}

variable "public_subnets" {
  default = ["subnet-0dc3ba8b0f9216b7f","subnet-09905eb9f57e2c6d2", "subnet-08533eecc09cb650d"]
}
