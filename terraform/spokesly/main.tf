provider "aws" {
    profile =                 "${var.profile}"
    shared_credentials_file = "~/.aws/credentials"
    region =                  "${var.region}"
}
resource "aws_key_pair" "main" {
  key_name_prefix   = terraform.workspace == "default" ? "insecure.${var.name}.${terraform.workspace}." : "${var.name}.${terraform.workspace}."
  public_key        = terraform.workspace == "default" ? file("ssh_keys/insecure.pub") : file("ssh_keys/${terraform.workspace}.pub")
}
module "vpc" {
  source                 = "./modules/terraform-aws-vpc"
  cidr                   = var.vpc_cidr
  name                   = "${var.name}.${terraform.workspace}"
  nat_per_az             = false
  separate_db_subnets    = false
  subnet_outer_offsets   = [ 4, 2 ]
  subnet_inner_offsets   = [ 2, 2 ]
  transit_gateway_attach = false
  allow_cidrs_default    = {}
  tags = merge({
    "Name"        = "${var.name}.${terraform.workspace}"
    "Environment" = terraform.workspace
  }, var.tags)
  public_subnet_tags = merge({
    "Name"        = "public.${var.name}.${terraform.workspace}"
    "Environment" = terraform.workspace
  }, var.tags)
  private_subnet_tags = merge({
    "Name"        = "private.${var.name}.${terraform.workspace}"
    "Environment" = terraform.workspace
  }, var.tags)
}
module "opsworks_stack" {
  source          = "./modules/terraform-aws-opsworks-stack"
  name            = "${var.name}.${terraform.workspace}"
  ssh_key_name    = aws_key_pair.main.key_name
  vpc_id          = module.vpc.id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  cookbook_url    = "${var.cookbook_url}"
  ssh_key         = "${var.ssh_key}"
  custom_json     = <<EOF
{
  "environment": "${terraform.workspace}"
}
EOF
}
module "lambda" {
  source          = "./modules/terraform-aws-lambda"
  stack_id        =   module.opsworks_stack.id
  name            = "${var.name}-${terraform.workspace}"
  repo_arn        = "${var.repo_arn}"
}