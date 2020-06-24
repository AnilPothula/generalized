resource "aws_subnet" "database" {
  vpc_id                  = aws_vpc.main.id
  count                   = var.separate_db_subnets ? length(local.subnet_list[2]) : 0
  cidr_block              = local.subnet_list[2][count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index + var.skip_az)
  map_public_ip_on_launch = false

  tags = {
    Name        = "private.database.${var.name}"
    Environment = terraform.workspace
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  count  = var.separate_db_subnets ? length(local.subnet_list[2]) : 0

  tags = {
    Name        = "private.database.${var.name}"
    Environment = terraform.workspace
  }
}

resource "aws_route" "database" {
  count                  = var.separate_db_subnets ? length(local.subnet_list[2]) : 0
  route_table_id         = element(aws_route_table.database.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "database" {
  count          = var.separate_db_subnets ? length(local.subnet_list[2]) : 0
  subnet_id      = element(aws_subnet.database.*.id, count.index)
  route_table_id = element(aws_route_table.database.*.id, count.index)
}
