variable "identifier" {
  description = "Name for the resources"
  type        = string
}

variable "description" {
  description = "Description for the IAM role"
  default     = "Created by terraform"
  type        = string
}

variable "aws_service_principal" {
  description = "The service principal allowed to assume this role. Example: 'ec2.amazonaws.com'"
  type        = string
}

variable "iam_policies_to_attach" {
  description = "List of ARNs of IAM policies to attach"
  default     = []
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}