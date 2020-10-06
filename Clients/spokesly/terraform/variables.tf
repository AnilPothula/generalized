# common paramters

variable "identifier" {
  description = "The name for the cluster"
  default     = "spokesly"
  type        = string
}


variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {
    Environment = "dev"
    Team = "Layer2"
    Developer  = "nclouds"
  }
  type        = map
}

# AWS batch resoource parameters
variable "desired_vcpus" {
  description = "Desired VCPUs"
  default     = 2
  type        = number
}

variable "max_vcpus" {
  description = "Max VCPUs"
  default     = 4
  type        = number
}

variable "min_vcpus" {
  description = "Min VCPUs"
  default     = 0
  type        = number
}

variable "ec2_key_pair" {
  description = "EC2 Key pair"
  default     = "oregon-sample-key"
  type        = string
}

variable "subnets" {
  description = "subnets"
  default     = "subnet-XXXXXX,subnet-XXXXXX,subnet-XXXXXX,subnet-XXXXXX"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  default     = "vpc-XXXXX"
  type        = string
}


variable "image" {
  description = "Docker image to be used"
  default     = "XXXXXXXXX.dkr.ecr.us-west-2.amazonaws.com/spokesly"
  type        = string
}

# cloudfront resource variables

variable "cf_initial_bucket_name" {
  description = "AWS s3 bucket name for cloudfront s3 origin"
  default = "spokesly-aws-batch"
  type        = string
}

variable "cloudfront_price_class" {
  type        = string
  description = "PriceClass for CloudFront distribution"
  default     = "PriceClass_100"
}

variable "domain" {
  description = "The domain name."
  default     = "test-something.com"
}

variable "fqdn" {
  description = "The domain name."
  default     = "spokeslynew.test-something.com"
}

# AWS Trigger job lambda variables

variable "trigger_lambda_name" {
  description = "Name of lambda function"
  default = "aws_trigger_spokesly"
  type        = string
}

variable "trigger_lambda_s3_bucket" {
  description = "lambda S3 bucket"
  type        = string
  default = "spokesly-lambda"
}

variable "trigger_lambda_s3_key" {
  description = "lambda S3 bucket key"
  type        = string
  default = "trigger-lambda.zip"
}

variable "aws_batch_bucketPrefix" {
  description = "AWS batch bucket prefix"
  type        = string
  default = "spokesly"
}

# Cleanup lambda variables

variable "cleanup_job_lambda_name" {
  description = "Name of lambda function"
  default = "cleanup_job_spokesly"
  type        = string
}

variable "cleanup_job_lambda_s3_bucket" {
  description = "lambda S3 bucket"
  type        = string
  default = "spokesly-lambda"
}

variable "cleanup_job_lambda_s3_key" {
  description = "lambda S3 bucket key"
  type        = string
  default = "lambda_cleanup.zip"
}