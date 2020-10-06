output "cf_id" {
  value       = "${aws_cloudfront_distribution.s3_distribution.id}"
  description = "ID of AWS CloudFront distribution"
}

output "cf_arn" {
  value       = "${aws_cloudfront_distribution.s3_distribution.arn}"
  description = "ID of AWS CloudFront distribution"
}

# output "cf_aliases" {
#   value       = "${var.aliases}"
#   description = "Extra CNAMEs of AWS CloudFront"
# }

output "cf_status" {
  value       = "${aws_cloudfront_distribution.s3_distribution.status}"
  description = "Current status of the distribution"
}

output "cf_domain_name" {
  value       = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
  description = "Domain name corresponding to the distribution"
}

# output "cf_etag" {
#   value       = "${aws_cloudfront_distribution.s3_distribution.etag}"
#   description = "Current version of the distribution's information"
# }

# output "cf_hosted_zone_id" {
#   value       = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
#   description = "CloudFront Route 53 zone ID"
# }

output "cf_origin_access_identity" {
  value       = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
  description = "A shortcut to the full path for the origin access identity to use in CloudFront"
}