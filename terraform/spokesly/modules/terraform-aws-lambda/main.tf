locals {
  default_tags = {
    Environment = terraform.workspace
    Name        = "${var.name}-${terraform.workspace}"
  }
  tags = merge(local.default_tags, var.tags)
}

resource "aws_codecommit_trigger" "codecommit_trigger" {
  repository_name = var.repo_name

  trigger {
    name            = "${var.name}-codecommit-trigger"
    events          = ["updateReference"]
    branches        = ["master"]
    destination_arn = "${aws_lambda_function.function.arn}"
  }

  depends_on = [aws_lambda_function.function,aws_lambda_permission.allow_from_lambda]
}

resource "aws_cloudwatch_log_group" "function_logs" {
  retention_in_days = 5
  name              = "/aws/lambda/${var.name}-${terraform.workspace}"

  tags = local.tags
}

resource "aws_lambda_function" "function" {
  source_code_hash               = "${filebase64sha256(var.filename)}"
  function_name                  = var.name
  description                    = var.description
  memory_size                    = var.memory_size
  # s3_bucket                      = var.s3_bucket
  filename                       = var.filename
  handler                        = var.handler
  publish                        = var.publish
  runtime                        = var.runtime
  timeout                        = var.timeout
  # s3_key                         = var.s3_key
  role                           = aws_iam_role.iam_for_lambda_tf.arn

  environment {
    variables = {
      STACK_ID = var.stack_id
    }
  }

  depends_on = [aws_cloudwatch_log_group.function_logs, aws_iam_role.iam_for_lambda_tf]

  tags = local.tags
}

resource "aws_lambda_permission" "allow_from_lambda" {
	statement_id      = "AllowExecutionFromLambda"
	action            = "lambda:InvokeFunction"
	function_name     = "${aws_lambda_function.function.function_name}"
  source_arn        = var.repo_arn
	principal         = "codecommit.amazonaws.com"
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "assume_role_policy" {
  name = "assume_role_policy"
  role = aws_iam_role.iam_for_lambda_tf.name
  depends_on = [aws_iam_role.iam_for_lambda_tf]

  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
          "Effect": "Allow",
          "Action": "logs:CreateLogGroup",
          "Resource": "*"
        },
        {
          "Effect": "Allow",
          "Action": [
                "opsworks:*",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "elasticloadbalancing:DescribeInstanceHealth",
                "elasticloadbalancing:DescribeLoadBalancers",
                "iam:GetRolePolicy",
                "iam:ListInstanceProfiles",
                "iam:ListRoles",
                "iam:ListUsers",
                "iam:PassRole"
            ],
            "Resource": "*"
        }
  ]
}
  EOF
}