variable "name" {
  type    = string
  default = "elasticsearch11"
}

variable "ssh_key_name" {
  type = string
}

variable "custom_cookbooks_source" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list
}

variable "public_subnets" {
  type = list
}

variable "custom_json" {}

variable "cookbook_url" {
  type    = string
}

variable "ssh_key" {
  type = string
}