locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.identifier}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_batch_job_queue" "job_queue" {
  name     = "${var.identifier}-${terraform.workspace}-job-queue"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    var.compute_environment_arn,
  ]
}