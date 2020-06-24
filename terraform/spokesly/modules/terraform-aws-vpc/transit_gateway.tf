resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count              = var.transit_gateway_attach ? 1 : 0
  subnet_ids         = aws_subnet.private.*.id
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.main.id

  tags = {
    Name        = var.name
    Environment = terraform.workspace
  }
}
