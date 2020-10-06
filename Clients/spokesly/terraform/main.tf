terraform {
  backend "s3" {
    bucket = "spokesly"
    key = "state.tfstate"
    region = "us-west-2"
  }
}

module "ecr" {
  source = "./modules/ecr"

  identifier    = var.identifier
  tags          = var.tags
}

module "batch_environment" {
  source = "./modules/batch_environment"

  identifier    = var.identifier
  max_vcpus     = var.max_vcpus
  desired_vcpus = var.desired_vcpus
  min_vcpus     = var.min_vcpus
  ec2_key_pair  = var.ec2_key_pair
  subnets       = var.subnets
  vpc_id        = var.vpc_id
  tags          = var.tags
  image         = var.image
}

module "cloudfront" {
  source = "./modules/cloudfront-route53"
  identifier    = var.identifier
  tags          = var.tags
  cf_initial_bucket_name = var.cf_initial_bucket_name
  cloudfront_price_class = var.cloudfront_price_class
  domain = var.domain
  fqdn = var.fqdn
}


module "batch_trigger_lambda" {
  source = "./modules/aws-batch-lambda"
  identifier    = var.identifier
  tags          = var.tags
  trigger_lambda_name = var.trigger_lambda_name
  trigger_lambda_s3_bucket = var.trigger_lambda_s3_bucket
  trigger_lambda_s3_key    = var.trigger_lambda_s3_key
  aws_batch_bucketPrefix    = var.aws_batch_bucketPrefix
  cf_origin_access_identity    = module.cloudfront.cf_origin_access_identity
}

module "cleanup_job_lambda" {
  source = "./modules/cleanup-job-lambda"
  identifier    = var.identifier
  tags          = var.tags
  cleanup_job_lambda_name = var.cleanup_job_lambda_name
  cleanup_job_lambda_s3_bucket = var.cleanup_job_lambda_s3_bucket
  cleanup_job_lambda_s3_key    = var.cleanup_job_lambda_s3_key
}