locals {
  default_tags = {
   
  }
  tags = merge(local.default_tags, var.tags)
  s3_origin_id = "${var.identifier}-${terraform.workspace}-s3-origin"
}

provider "aws" {
  alias = "main"
  region = "us-west-2"
}

provider "aws" {
  region = "us-east-1"
  alias = "cloudfront"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.b.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "example" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket" "b" {
  bucket = var.cf_initial_bucket_name
  acl    = "private"
  tags = local.tags
  force_destroy = true
}



resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.identifier}-${terraform.workspace}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config { 
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.identifier}-${terraform.workspace}"
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "${var.cloudfront_price_class}"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "IN"]
    }
  }

  tags = local.tags
  aliases = [var.fqdn]
  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate_validation.cert.certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}


# ACM Certificate generation

resource "aws_acm_certificate" "cert" {
  provider          = aws.cloudfront
  domain_name       = "${var.fqdn}"
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  provider = aws.cloudfront
  # name     = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  # type     = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  # zone_id  = "${data.aws_route53_zone.main.id}"
  # records  = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  # ttl      = 60

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id  = "${data.aws_route53_zone.main.id}"
    }
  }

  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id

}

resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.cloudfront
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}


# Route 53 record for the static site

data "aws_route53_zone" "main" {
  provider     = aws.main
  name         = "${var.domain}"
  private_zone = false
}


resource "aws_route53_record" "web" {
  provider = aws.main
  zone_id  = "${data.aws_route53_zone.main.zone_id}"
  name     = "${var.fqdn}"
  type     = "A"

  alias {
    name    = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
