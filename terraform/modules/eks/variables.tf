variable "environment" {
  description = "Environment where the cluster will be deployed"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "nclouds"
}

# see https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html for the ami for each aws-region
variable "k8s_version" {
  type        = string
  description = "k8s version"
  default     = "1.14"
}

variable "autoscaler_version" {
  description = "Version of the cluster autoscaler"
  type        = string
  default     = "v1.3.7"
}

variable "external_dns_version" {
  description = "Version of external dns pod"
  type        = string
  default     = "v0.5.11"
}

variable "kube2iam_version" {
  description = "Version of kube2iam daemon"
  type        = string
  default     = "0.10.4"
}

variable "dashboard_version" {
  description = "version of the dashboard"
  type        = string
  default     = "v1.10.1"
}

variable "metrics_server_version" {
  description = "variable of metrics server, needed for hpa"
  type        = string
  default     = "v0.3.1"
}

variable "efs_namespace" {
  description = "Namespace where the efs storage class will be executed"
  type        = string
  default     = "kube-system"
}

variable "efs_provisioner_version" {
  description = "Version of the efs provisioner"
  type        = string
  default     = "v1.0.0-k8s1.10"
}

variable "private_domain_name" {
  description = "Private domain for the services"
  type        = string
  default     = ""
}

variable "public_domain_name" {
  description = "Public domain for the public services"
  type        = string
  default     = ""
}

variable "worker" {
  type        = map(string)
  description = "Map of EKS workers settings (instance-type, min-size, max-size, key_name, volume_type, volume_size)"
  default = {
    instance-type = "t3.large"
    min-size      = "2"
    max-size      = "4"
    key_name      = ""
    volume_type   = "gp2"
    volume_size   = 100
  }
}

variable "vpc_id" {
  type        = string
  description = "Id of the vpc where the cluster will be deploy"
}

variable "vpn_sg" {
  type        = string
  description = "Security group of the vpn to allow connections over ssh to the worker nodes"
  default     = ""
}

variable "private_subnets" {
  type        = list(string)
  description = "list of private subnets where the cluster will be deploy"
}

variable "private_subnets_count" {
  type        = string
  description = "count of private subnets, due to an error while trying to count the subnets when they have not been created yet we have to send the value from outside the module "
  default     = 0
}

variable "public_subnets" {
  type        = list(string)
  description = "list of private subnets where the cluster will be deploy"
}

variable "worker_node_policies" {
  type        = list(string)
  description = "Worker node default policies"
  default = [
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryReadOnly",
    "CloudWatchFullAccess",
  ]
}

variable "cluster_policies" {
  description = "Cluster default policies"
  type        = list(string)
  default = [
    "AmazonEKSClusterPolicy",
    "AmazonEKSServicePolicy",
  ]
}

variable "render_files" {
  description = "Wheter render the templates or not"
  default     = true
  type        = string
}

variable "deploy_efs" {
  description = "Wheter create EFS or not"
  default     = false
  type        = string
}

