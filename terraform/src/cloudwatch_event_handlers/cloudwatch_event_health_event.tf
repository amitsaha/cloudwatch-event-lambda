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
