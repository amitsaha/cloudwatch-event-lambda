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
