resource "aws_iam_role" "cloudwatch_event_handler_lambda_iam" {
  name = "cloudwatch_event_handler_lambda_iam"

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

resource "aws_lambda_function" "cloudwatch_event_handler" {
  function_name    = "cloudwatch_event_handler"
  role             = "${aws_iam_role.cloudwatch_event_handler_lambda_iam.arn}"
  handler          = "main.handler"
  runtime          = "python3.6"

  s3_bucket         = "aws-health-notif-demo-lambda-artifacts"
  s3_key            = "cloudwatch-event-handler/src.zip"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.cloudwatch_event_handler.function_name}"
  principal      = "events.amazonaws.com"
  source_arn     = "${aws_cloudwatch_event_rule.ec2_state_change.arn}"
  # qualifier      = "${aws_lambda_alias.test_alias.name}"
}
