output "output" {
  value = {
    aws_db_parameter_group = aws_db_parameter_group.main.id
    aws_db_subnet_group    = aws_db_subnet_group.main.id
    aws_db_ssm_name        = aws_ssm_parameter.secret.name
    identifier             = aws_db_instance.main.identifier
    aws_db_id              = aws_db_instance.main.id
    username               = aws_db_instance.main.username
    address                = aws_db_instance.main.address
    port                   = aws_db_instance.main.port
    name                   = aws_db_instance.main.name
  }
}