# Configure the AWS Provider for Development Account
provider "aws" {
  version = "~> 2.39"
  profile = "nclouds"
  region  = "us-east-1"
}
