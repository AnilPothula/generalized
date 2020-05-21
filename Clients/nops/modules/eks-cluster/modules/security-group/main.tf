locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_security_group" "default" {
  description = var.description
  vpc_id      = var.vpc_id
  name        = "${var.identifier}-${terraform.workspace}"

  tags        = local.tags
}

resource "aws_security_group_rule" "default_ingress_rules" {
  count             = length(var.ingress_rule_list)

  security_group_id = aws_security_group.default.id
  cidr_blocks       = var.ingress_rule_list[count.index].cidr_blocks
  description       = var.ingress_rule_list[count.index].description
  from_port         = var.ingress_rule_list[count.index].from_port
  protocol          = var.ingress_rule_list[count.index].protocol
  to_port           = var.ingress_rule_list[count.index].to_port
  type              = "ingress"
}

resource "aws_security_group_rule" "self" {
  security_group_id = aws_security_group.default.id
  description       = "Managed by terraform"
  from_port         = 0
  protocol          = "all"
  to_port           = 65535
  self              = true
  type              = "ingress"
}

resource "aws_security_group_rule" "default_egress_rules" {
  count             = length(var.egress_rule_list)

  security_group_id = aws_security_group.default.id
  cidr_blocks       = var.egress_rule_list[count.index].cidr_blocks
  description       = var.egress_rule_list[count.index].description
  from_port         = var.egress_rule_list[count.index].from_port
  protocol          = var.egress_rule_list[count.index].protocol
  to_port           = var.egress_rule_list[count.index].to_port
  type              = "egress"
}