resource "aws_cloudwatch_event_rule" "ec2_state_change" {
  name        = "ec2-state-change-event"
  description = "Notify when there is a state change in EC2 instances"

  event_pattern = <<PATTERN
{
  "source": [ "aws.ec2" ],
  "detail-type": [ "EC2 Instance State-change Notification" ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "ec2_state_change" {
  rule      = "${aws_cloudwatch_event_rule.ec2_state_change.name}"
  target_id = "InvokeLambda"
  arn       = "${aws_lambda_function.ec2_state_change.arn}"
}

resource "aws_iam_role" "ec2_state_change_lambda_iam" {
  name = "ec2_state_change_lambda_iam"

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

resource "aws_iam_role_policy" "ec2_state_change_lambda_cloudwatch_logging" {
  name = "lambda-cloudwatch-logging"
  role = "${aws_iam_role.ec2_state_change_lambda_iam.id}"

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

resource "aws_lambda_function" "ec2_state_change" {
  function_name = "ec2_state_change"
  role          = "${aws_iam_role.ec2_state_change_lambda_iam.arn}"
  handler       = "main.handler"
  runtime       = "python3.6"

  s3_bucket         = "aws-health-notif-demo-lambda-artifacts"
  s3_key            = "ec2-state-change/src.zip"
  s3_object_version = "${var.ec2_state_change_handler_version}"
}

resource "aws_lambda_permission" "ec2_state_change_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.ec2_state_change.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.ec2_state_change.arn}"
}
