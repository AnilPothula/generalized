output "rds" {
    value = {
        address    = aws_db_instance.default.address
        port       = aws_db_instance.default.port
        name       = aws_db_instance.default.name
        username   = aws_db_instance.default.username
        identifier = aws_db_instance.default.identifier
    }
}

output "aws_db_id" {
    value = aws_db_instance.default.id
}