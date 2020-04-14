variable "identifier" {
    description = "A name identifier for the ElasticSearch domain."
    default     = "domain-name"
    type        = string
}

# variable "security_group_ids" {
#     description = "List of security group ids."
#     default     = ["sg-xxxxxxxxxxxxx"]
#     type        = list(string)
# }

# variable "subnets_ids" {
#     description = "List of all the subnets"
#     default     = ["subnet-xxxxxxxxxxxxx"]
#     type        = list(string)
# }

variable "ebs_enabled" {
    description = "Whether EBS volumes are attached to data nodes in the domain."
    default     = false
    type        = bool
}

variable "volume_size" {
    description = "The size of EBS volumes attached to data nodes (in GB)."
    default     = 20
    type        = number
}

variable "iops" {
    description = "The baseline input/output (I/O) performance of EBS volumes attached to data nodes"
    default     = 0
    type        = number
}


variable "zone_awareness_enabled" {
    description = "Configuration block containing zone awareness settings. Documented below."
    default     = false
    type        = bool
}

variable "instance_type" {
    description = "Instance type of data nodes in the cluster."
    default     = "m3.medium.elasticsearch"
    type        = string
}

variable "volume_type" {
    description = "The type of EBS volumes attached to data nodes."
    default     = "gp2"
    type        = string
}

variable "instance_count" {
    description = "The number of data nodes (instances) to use in the Amazon ES domain"
    default     = 2
    type        = number
}

variable "dedicated_master_enabled" {
    description = "Indicates whether dedicated master nodes are enabled for the cluster."
    default     = true
    type        = bool
}


variable "elasticsearch_version" {
    description = "The version of Elasticsearch to use."
    default     = "2.3"
    type        = string
}

variable "dedicated_master_type" {
    description = "Instance type of the dedicated master nodes in the cluster."
    default     = "m3.medium.elasticsearch"
    type        = string
}

variable "dedicated_master_count" {
    description = "Number of dedicated master nodes in the cluster."
    default     = 3
    type        = number
}

variable "automated_snapshot_start_hour" {
    description = "Hour during which the service takes an automated daily snapshot of the indices in the domain."
    default     = 0
    type        = number

    # variable_validation {
    #     condition     = var.ss_hour > 0 && var.ss_hour < 24
    #     error_message = "Snapshot hour must be between 0 and 23 hour."
    # }
}

variable "tags" {
    description = "Tags to be applied to the resource"
    default     = {TagName = "TagValue"}
    type        = map
}