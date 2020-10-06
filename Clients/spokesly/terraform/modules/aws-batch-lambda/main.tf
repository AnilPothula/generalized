locals {
  default_tags = {
   
  }
  tags = merge(local.default_tags, var.tags)
  s3_origin_id = "${var.identifier}-${terraform.workspace}-s3-origin"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.identifier}-${terraform.workspace}-iam_for_batch_lambda"

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


resource "aws_iam_policy" "lambda_batch" {
  name        = "${var.identifier}-${terraform.workspace}-lambda_batch"
  path        = "/"
  description = "IAM policy for aws batch for lambda"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "batch:Describe*",
        "batch:List*",
        "batch:SubmitJob"
      ],
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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_batch.arn
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.spokesly_aws_batch_lambda.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "spokesly_aws_batch_lambda" {
  s3_bucket = "${var.trigger_lambda_s3_bucket}"
  s3_key    = "${var.trigger_lambda_s3_key}"
  function_name = "${var.trigger_lambda_name}"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime = "python3.6"
  timeout = 300
  tags = local.tags
  environment {
    variables = {
      JobDefinition = "${var.identifier}-${terraform.workspace}-job_definition"
      JobQueue = "${var.identifier}-${terraform.workspace}-queue"
      bucketPrefix = "${var.aws_batch_bucketPrefix}"
      cfOriginAccessIdentity = "${var.cf_origin_access_identity}"
    }
  }
}
