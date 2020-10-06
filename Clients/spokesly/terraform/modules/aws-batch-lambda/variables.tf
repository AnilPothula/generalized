variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "trigger_lambda_name" {
  description = "Name of lambda function"
  type        = string
}

variable "trigger_lambda_s3_bucket" {
  description = "lambda S3 bucket"
  type        = string
  default = "lambda-spokesly"
}

variable "trigger_lambda_s3_key" {
  description = "lambda S3 bucket key"
  type        = string
  default = "lambda.zip"
}

variable "aws_batch_bucketPrefix" {
  description = "AWS batch bucket prefix"
  type        = string
  default = "spokesly"
}

variable "cf_origin_access_identity" {
  description = "cf Origin Access Identity"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}
