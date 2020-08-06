output "output" {
  value = {
    compute_environment_arn = aws_batch_compute_environment.compute_environment.arn
  }
}
