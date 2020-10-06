variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "scan_on_push"{
  description = "Enable image scanning on push"
  default     = true
  type        = bool
}

variable "image_tag_mutability" {
  description = "tag capacity to change"
  default     = "MUTABLE"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}
