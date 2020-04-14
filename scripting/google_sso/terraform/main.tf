######################
###### AWS IDP #######
######################

data "aws_caller_identity" "current" {}

resource "aws_iam_saml_provider" "default" {
  name                   = "${var.idp_name}"
  saml_metadata_document = "${file("google-idp.xml")}"
}

######################
##### Admin Role #####
######################

resource "aws_iam_role" "idp_admin" {
  name = "google-idp-admin"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/${var.idp_name}"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "idp_admin" {
  role       = "${aws_iam_role.idp_admin.name}"
  policy_arn = "${aws_iam_policy.idp_admin.arn}"
}

resource "aws_iam_policy" "idp_admin" {
  name = "google-idp-admin"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF
}

######################
### Read Only Role ###
######################

resource "aws_iam_role" "idp_read_only" {
  name = "google-idp-read-only"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/${var.idp_name}"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "idp_read_only" {
  role       = "${aws_iam_role.idp_read_only.name}"
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "idp_read_only_kms" {
  role       = "${aws_iam_role.idp_read_only.name}"
  policy_arn = "${aws_iam_policy.idp_read_only.arn}"
}

resource "aws_iam_policy" "idp_read_only" {
  name = "google-idp-read-only"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF
}

######################
### KMS Admin Role ###
######################

resource "aws_iam_role" "idp_kms_admin" {
  name = "google-idp-kms-admin"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/${var.idp_name}"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "idp_kms_admin" {
  role       = "${aws_iam_role.idp_kms_admin.name}"
  policy_arn = "${aws_iam_policy.idp_kms_admin.arn}"
}

resource "aws_iam_policy" "idp_kms_admin" {
  name = "google-idp-kms-admin"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF
}

######################
####### S3 Role ######
######################

resource "aws_iam_role" "idp_digital_production" {
  name = "google-idp-s3"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/${var.idp_name}"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": "https://signin.aws.amazon.com/saml"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "idp_digital_production" {
  role       = "${aws_iam_role.idp_digital_production.name}"
  policy_arn = "${aws_iam_policy.idp_digital_production.arn}"
}

resource "aws_iam_policy" "idp_digital_production" {
  name = "google-idp-s3"
  policy = "${data.aws_iam_policy_document.idp_digital_production.0.json}"
}


data "aws_iam_policy_document" "idp_digital_production" {
  statement {
    actions = ["s3:*"]
    resources = ["${concat(formatlist("arn:aws:s3:::%s/*",var.idp_digital_production_buckets), formatlist("arn:aws:s3:::%s",var.idp_digital_production_buckets))}"]
  }

}
