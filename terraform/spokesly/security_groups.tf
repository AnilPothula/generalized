resource "aws_security_group" "main" {
  name        = "allow elasticsearch traffic"
  description = "allow elasticsearch traffic"
  vpc_id      = module.vpc.id

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "TCP"
    cidr_blocks = [ module.vpc.cidr ]
    description = "allow elasticsearch http traffic"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
    description = "allow self"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    security_groups = [aws_security_group.lb.id]
    description = "allow self"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "lb" {
  name        = "lb_opsworks_sg"
  description = "Security group for the load balancer"
  vpc_id      = module.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all traffic"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks     = [ "0.0.0.0/0" ]
  }
}