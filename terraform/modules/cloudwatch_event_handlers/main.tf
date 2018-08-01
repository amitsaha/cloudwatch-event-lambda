resource "aws_cloudwatch_event_rule" "rule" {
  name        = "${var.cloudwatch_event_rule_name}"
  description = "${var.cloudwatch_event_rule_description}"

  event_pattern = "${var.cloudwatch_event_rule_pattern}"
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = "${aws_cloudwatch_event_rule.rule.name}"  
  arn       = "${aws_lambda_function.lambda.arn}"
}

resource "aws_iam_role" "lambda" {
  name = "${var.lambda_iam_role_name}"

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

resource "aws_iam_role_policy" "lambda_cloudwatch_logging" {
  name = "lambda-cloudwatch-logging"
  role = "${aws_iam_role.lambda.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.lambda_function_name}"
  role          = "${aws_iam_role.lambda.arn}"
  handler       = "${var.lambda_handler}"
  runtime       = "${var.lambda_runtime}"

  s3_bucket         = "${var.lambda_artifacts_bucket_name}"
  s3_key            = "${var.lambda_artifacts_bucket_key}"
  s3_object_version = "${var.lambda_version}"

  environment {
        variables = "${var.lambda_environment}"
  }
}

resource "aws_lambda_permission" "cloudwatch_lambda_execution" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.rule.arn}"
}
