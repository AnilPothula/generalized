output "arn" {
  value = aws_iam_role.role.arn
}

output "id" {
  value = aws_iam_role.role.id
}

output "name" {
  value = aws_iam_role.role.name
}

output "unique_id" {
  value = aws_iam_role.role.unique_id
}

output "profile_arn" {
  value = aws_iam_instance_profile.profile.arn
}

output "profile_id" {
  value = aws_iam_instance_profile.profile.id
}