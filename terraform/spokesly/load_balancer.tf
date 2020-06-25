resource "aws_elb" "elb" {
  connection_draining_timeout = 400
  cross_zone_load_balancing   = true
  connection_draining         = true
  idle_timeout                = 400
  subnets                     = module.vpc.public_subnets
  name                        = "opswork-loadbalancer"
  security_groups             = [aws_security_group.lb.id]
  listener {
    instance_protocol = "http"
    instance_port     = 9100
    lb_protocol       = "http"
    lb_port           = 80
  }
  health_check {
    unhealthy_threshold = 2
    healthy_threshold   = 2
    interval            = 30
    timeout             = 3
    target              = "HTTP:9100/"
  }
}