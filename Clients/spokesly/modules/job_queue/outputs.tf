output "output" {
  value = {
    queue = aws_batch_job_queue.job_queue
  }
}
