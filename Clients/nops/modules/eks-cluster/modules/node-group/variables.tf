variable "identifier" {
  description = "The name for the resource"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
  default     = false
  type        = bool
}

variable "iam_instance_profile" {
  description = "The name attribute of the IAM instance profile to associate with launched instances"
  type        = string
}

variable "user_data_base64" {
  description = "base64-encoded user-data"
  default     = ""
  type        = string
}

variable "security_groups" {
  description = "List of security groups to assign to instances"
  default     = []
  type        = list(string)
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  default     = true
  type        = bool
}

variable "image_id" {
  description = "AMI to use"
  type        = string
}

variable "key_name" {
  description = "The name of the key-pair to use"
  type        = string
}

variable "volume_size" {
  description = "The size of the root ebs volume"
  default     = 50
  type        = number
}

variable "volume_type" {
  description = "The type of volume. Can be 'standard', 'gp2', or 'io1'"
  default     = "gp2"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance type to use"
  default     = "t2.micro"
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  default     = 1
  type        = number
}

variable "max_size" {
  description = "Maximun number of instances in the ASG"
  default     = 5
  type        = number
}

variable "eks_cluster_id" {
  description = "If set add the tag kubernetes.io/cluster/<cluster-name> = owned"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}

variable "estimated_instance_warmup" {
  description = "The estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics. "
  default     = 300
  type        = number
}

variable "metric_aggregation_type" {
  description = "Metric aggregation type"
  default     = "Average"
  type        = string
}

variable "adjustment_type" {
  description = "Adjustment type for the autoscaling policy."
  default     = "ChangeInCapacity"
  type        = string
}

variable "policy_type" {
  description = "Policy type."
  default     = "StepScaling"
  type        = string
}
