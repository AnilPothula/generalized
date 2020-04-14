resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = aws_subnet.public_subnets.*.id
  tags = {
    Name = "${var.environment}-acl"
  }
}

locals {
  ip_whitelist = split(
    ",",
    length(var.ip_whitelist) > 0 ? join(",", concat(var.ip_whitelist, [var.vpc["cidr"]])) : "0.0.0.0/0",
  )
}

resource "aws_network_acl_rule" "ingress-whitelist" {
  count          = length(local.ip_whitelist)
  network_acl_id = aws_network_acl.main.id
  rule_number    = 200 + count.index
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = local.ip_whitelist[count.index]
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "ingress-ephemeral-ports" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 10
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "egress-all" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 1000
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "ingress-blacklist" {
  count          = length(var.ip_blacklist)
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100 + count.index
  egress         = false
  protocol       = -1
  rule_action    = "deny"
  cidr_block     = var.ip_blacklist[count.index]
  from_port      = 0
  to_port        = 0
}

