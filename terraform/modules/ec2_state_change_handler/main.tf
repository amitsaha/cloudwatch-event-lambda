variable "lambda_artifacts_bucket_name" {
    type = "string"
}

variable "ec2_state_change_handler_version" {
    type = "string"
}

module "ec2_state_change_handler" {

    source = "../cloudwatch_event_handlers"

    cloudwatch_event_rule_name = "ec2-state-change-event"
    cloudwatch_event_rule_description = "Notify when there is a state change in EC2 instances"
    cloudwatch_event_rule_pattern = <<PATTERN
{
  "source": [ "aws.ec2" ],
  "detail-type": [ "EC2 Instance State-change Notification" ]
}
PATTERN
     lambda_iam_role_name = "ec2_state_change_lambda_iam"
     lambda_function_name = "ec2_state_change"
     lambda_handler = "main.handler"
     lambda_runtime = "python3.6"
     
     lambda_artifacts_bucket_name = "${var.lambda_artifacts_bucket_name}"
     lambda_artifacts_bucket_key = "ec2-state-change/src.zip"
     lambda_version = "${var.ec2_state_change_handler_version}"
}