variable "identifier" {
  description = "The name for the cluster"
  type        = string
}

variable "cf_initial_bucket_name" {
  description = "The name for the bucket"
  type        = string
}

variable "cloudfront_price_class" {
  type        = string
  description = "PriceClass for CloudFront distribution"
  default     = "PriceClass_100"
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map
}

variable "domain" {
  description = "The domain name."
  default     = "test-something.com"
}

variable "fqdn" {
  description = "The domain name."
  default     = "spokeslynew.test-something.com"
}