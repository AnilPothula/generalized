variable "vpc_id" {
  description = "VPC id for the resources"
  default     = ""
  type        = string
}

variable "sg_id" {
  description = "Security group"
  default     = ""
  type        = string
}

variable "subnets" {
  description = "A list of VPC subnet IDs"
  default     = []
  type        = list(string)
}

variable "rds_database_name" {
  description = "Name of the database"
  default     = ""
  type        = string
}

variable "rds_master_username" {
  description = "Master username for the database"
  default     = ""
  type        = string
}

variable "rds_instance_class" {
  description = "Instance class for the database"
  default     = ""
  type        = string
}

variable "rds_allocated_storage" {
  description = "Allocated storage"
  default     = 10
  type        = number
}

variable "rds_app_db_names" {
  description = "Create App DB names with these names"
  default     = ""
  type        = string
}

variable "rds_engine_version" {
  description = "Engine version for the db"
  default     = "10.11"
  type        = string
}

variable "rds_parameter_group_family" {
  description = "Parameter group family for the instance"
  default     = ""
  type        = string
}

variable "multi_az" {
  description = "Set to 'true' to deploy the rds instance as multi-az"
  default     = false
  type        = bool
}

variable "backup_retention_period" {
  description = "Backup retention period"
  default     = 15
  type        = number
}

variable "storage_type" {
  description = "Storage type for the db"
  default     = "gp2"
  type        = string
}


variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  default     = true
  type        = bool
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  default     = true
  type        = bool
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  default     = false
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  default     = true
  type        = bool
}

variable "engine" {
  description = "Define the engine for the database"
  default     = ""
  type        = string
}

variable "identifier" {
  description = "The name for the resources"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}