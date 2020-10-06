locals {
  default_tags = {
   
  }
  tags = merge(local.default_tags, var.tags)
  s3_origin_id = "${var.identifier}-${terraform.workspace}-s3-origin"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.identifier}-${terraform.workspace}-iam_for_cleanup_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy" "lambda_cleanup_job" {
  name        = "${var.identifier}-${terraform.workspace}-lambda_cleanup_job"
  path        = "/"
  description = "IAM policy for aws cleanup_job for lambda"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "cloudfront:*",
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": "s3:*",
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.spokesly_cleanup_job_lambda.function_name}"
  retention_in_days = 14
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_cleanup_job.arn
}

resource "aws_lambda_function" "spokesly_cleanup_job_lambda" {
  s3_bucket = "${var.cleanup_job_lambda_s3_bucket}"
  s3_key    = "${var.cleanup_job_lambda_s3_key}"
  function_name = "${var.cleanup_job_lambda_name}"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime = "python3.6"
  timeout = 300
  tags = local.tags
}
