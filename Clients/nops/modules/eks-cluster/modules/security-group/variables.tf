variable "description" {
  description = "A description for the security group"
  default     = "Security group created by terraform"
  type        = string
}

variable "identifier" {
  description = "The name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "The id of the VPC where the security group is being deployed"
  type        = string
}

variable "ingress_rule_list" {
  description = "List of security group ingress rules"
  default     = []
  type        = list(object({
                  cidr_blocks       = list(string),
                  description       = string,
                  from_port         = number,
                  protocol          = string,
                  to_port           = number
                }))
}

variable "egress_rule_list" {
  description = "List of security group egress rules"
  default     = [
                  {
                    cidr_blocks = ["0.0.0.0/0"],
                    description = "Default egress rule",
                    from_port   = 0,
                    protocol    = "all",
                    to_port     = 65535
                  }
                ]
  type        = list(object({
                  cidr_blocks       = list(string),
                  description       = string,
                  from_port         = number,
                  protocol          = string,
                  to_port           = number
                }))
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}