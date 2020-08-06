provider "aws" {
    region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "shariq-teraform-state"
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
}

module "job_queue" {
  source = "./modules/job_queue"

  identifier    = var.identifier
  compute_environment_arn = module.batch_environment.output.compute_environment_arn
  tags          = var.tags
}