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

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = "${aws_cloudwatch_event_rule.ec2_state_change.name}"
  target_id = "InvokeLambda"
  arn       = "${aws_lambda_function.ec2_state_change.arn}"
}
