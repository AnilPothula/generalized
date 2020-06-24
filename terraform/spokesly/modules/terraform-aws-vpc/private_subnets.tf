resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(local.subnet_list[1])
  cidr_block              = local.subnet_list[1][count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index + var.skip_az)
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name        = "private.${var.name}"
      Environment = terraform.workspace
    },
    var.tags,
    var.private_subnet_tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = length(local.subnet_list[1])

  tags = {
    Name        = "private.${var.name}"
    Environment = terraform.workspace
  }
}

resource "aws_route" "private" {
  count                  = length(local.subnet_list[1])
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(local.subnet_list[1])
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
