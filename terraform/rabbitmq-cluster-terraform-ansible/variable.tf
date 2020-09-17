### variable.tf
variable "aws_region" {
  description = "AWS region on which we will setup the rabbitmq cluster"
  default = "us-east-1"
}
variable "access_key" {
  default = "XXXXXXXXXXXXXXXXXX"
  description = "the user aws access key"
}
variable "secret_key" {
  default = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  description = "the user aws secret key"
}
variable "aws_amis" {
  description = "Ubuntu 18.04 Base AMI to launch the instances"
  default = {
  us-east-1 = "ami-05e00da24aba682c3"
  }
}
variable "instance_type" {
  description = "Instance type"
  default = "t2.micro"
}
variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/praveen/Desktop/ssh/parveen-rabbitmq.pem"
}
variable "key_name" {
  description = "Desired name of Keypair..."
  default = "parveen-rabbitmq"
}
variable "bootstrap_path" {
  description = "Script to install Docker Engine"
  default = "install_docker_machine_compose.sh"
}
