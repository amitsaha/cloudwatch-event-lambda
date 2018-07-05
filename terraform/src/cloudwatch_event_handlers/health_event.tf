resource "aws_cloudwatch_event_rule" "health_event_notify" {
  name        = "health-event"
  description = "Notify when there is a scheduled health event across AWS resources"

  event_pattern = <<PATTERN
{
  "source": [ "aws.health" ],
  "detail-type": [ "AWS Health Event" ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "health_event_lambda" {
  rule      = "${aws_cloudwatch_event_rule.health_event_notify.name}"
  target_id = "InvokeLambda"
  arn       = "${aws_lambda_function.health_event_notify.arn}"
}
resource "aws_iam_role" "health_event_notify_lambda_iam" {
  name = "health_event_notify_lambda_iam"

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

resource "aws_iam_role_policy" "health_event_notify_cloudwatch_logging" {
  name = "lambda-cloudwatch-logging"
  role = "${aws_iam_role.health_event_notify_lambda_iam.id}"

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

resource "aws_lambda_function" "health_event_notify" {
  function_name = "health_event_notify"
  role          = "${aws_iam_role.health_event_notify_lambda_iam.arn}"
  handler       = "main.handler"
  runtime       = "python3.6"

  s3_bucket         = "aws-health-notif-demo-lambda-artifacts"
  s3_key            = "health-event/src.zip"
  s3_object_version = "${var.health_event_notify_handler_version}"
}

resource "aws_lambda_permission" "health_event_notify_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.health_event_notify.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.health_event_notify.arn}"
}
