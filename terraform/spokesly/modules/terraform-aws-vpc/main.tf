locals {
  allow_cidrs_default = merge(var.allow_cidrs_default, { self = aws_vpc.main.cidr_block})
  subnet_list         = [ for cidr_block in cidrsubnets(var.cidr, var.subnet_outer_offsets...) : cidrsubnets(cidr_block, var.subnet_inner_offsets...) ]
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name        = "${var.name}"
      Environment = terraform.workspace
    },
    var.tags
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = var.name
    Environment = terraform.workspace
  }
}

resource "aws_eip" "nat" {
  vpc   = true
  count = local.nat_count

  tags = {
    Name        = var.name
    Environment = terraform.workspace
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  count         = local.nat_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
}

resource "aws_default_security_group" "default" {
  vpc_id                 = aws_vpc.main.id
  revoke_rules_on_delete = true

  ingress {
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
    description = "self"
  }

  dynamic "ingress" {
    for_each = local.allow_cidrs_default

    content {
      protocol    = -1
      from_port   = 0
      to_port     = 0
      cidr_blocks = list(ingress.value)
      description = ingress.key
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "default.${var.name}"
    Environment = terraform.workspace
  }
}
