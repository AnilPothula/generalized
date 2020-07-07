variable "name" {
  description = "Name for the lambda function"
  type        = string
}

variable "description" {
  description = "Lambda function for codecommit"
  default     = "Lambda function for codecommit"
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code"
  default     = "index.handler"
  type        = string
}

variable "filename" {
  description = "Filename inside the bucket"
  default     = "index.zip"
  type        = string
}

variable "repo_arn" {
  description = "Repository ARN"
  default     = "arn:aws:codecommit:us-east-1:695292474035:layer2"
  type        = string
}


variable "runtime" {
  description = "Runtime"
  default     = "nodejs12.x"
  type        = string
}

variable "repo_name" {
  description = "Codecommit repo"
  default     = "layer2"
  type        = string
}

variable "s3_bucket" {
  description = "s3 bucjet to store the code"
  default     = "codecommit-lambda-function"
  type        = string
}

variable "s3_key" {
  description = "s3 key on the specific bucket"
  default     = "index.zip"
  type        = string
}

variable "timeout" {
  description = "Time out for the lambda function"
  default     = 120
  type        = number
}

variable "publish" {
  description = "Time out for the lambda function"
  default     = true
  type        = bool
}

variable "memory_size" {
  description = "Memory size for the lambda function code"
  default     = 128
  type        = number
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}

variable "environment" {
  description = "A map that defines environment variables for the Lambda function"
  default     = {
    STACK_ID = "6fde2126-24e6-4991-adc4-8a829ed160cb"
  }
  type        = map
}

variable "stack_id" {
  description = "Opswork stack id"
  type        = string
}