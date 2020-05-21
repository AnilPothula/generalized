  
output "launch_configuration_id" {
  value = aws_launch_configuration.launch_config.id
}

output "launch_configuration_arn" {
  value = aws_launch_configuration.launch_config.arn
}

output "launch_configuration_name" {
  value = aws_launch_configuration.launch_config.name
}

output "asg_id" {
  value = aws_autoscaling_group.asg.id
}

output "asg_arn" {
  value = aws_autoscaling_group.asg.arn
}

output "asg_name" {
  value = aws_autoscaling_group.asg.name
}