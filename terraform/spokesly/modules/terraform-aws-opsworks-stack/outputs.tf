output "id" {
  value = aws_opsworks_stack.main.id
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.ec2.arn
}
