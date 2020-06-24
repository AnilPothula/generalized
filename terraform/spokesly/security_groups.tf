resource "aws_security_group" "main" {
  name        = "allow elasticsearch traffic"
  description = "allow elasticsearch traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "TCP"
    cidr_blocks = [ var.vpc_cidr ]
    description = "allow elasticsearch http traffic"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
    description = "allow self"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = [ "0.0.0.0/0" ]
  }
}
