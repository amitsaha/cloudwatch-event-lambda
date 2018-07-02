resource "aws_cloudwatch_event_rule" "ec2_state_change" {
  name        = "ec2-state-change-event"
  description = "Notify when there is a state change in EC2 instances"

  event_pattern = <<PATTERN
{
  "source": [ "aws.ec2" ],
  "detail-type": [ "EC2 Instance State-change Notification" ],
  "detail": {
    "state": [ "running" ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = "${aws_cloudwatch_event_rule.ec2_state_chang4e.name}"
  target_id = "InvokeLambda"
  arn       = "${aws_lambda_function.cloudwatch_event_handler}"
}
