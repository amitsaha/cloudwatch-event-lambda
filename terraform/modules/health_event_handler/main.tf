variable "lambda_artifacts_bucket_name" {
    type = "string"
}

variable "health_event_handler_version" {
    type = "string"
}

variable "health_event_handler_environment" {
  type = "map"
  default = {}
}


module "health_event_handler" {

    source = "../cloudwatch_event_handlers"

    cloudwatch_event_rule_name = "health-event"
    cloudwatch_event_rule_description = "Invoke a lambda function when there is a scheduled health event"
    cloudwatch_event_rule_pattern = <<PATTERN
{
  "source": [ "aws.health" ],
  "detail-type": [ "AWS Health Event" ]
}
PATTERN

    lambda_iam_role_name = "health_event_lambda"
    lambda_function_name = "health_event"
    lambda_handler = "main.handler"
    lambda_runtime = "python3.6"

    lambda_artifacts_bucket_name = "${var.lambda_artifacts_bucket_name}"
    lambda_artifacts_bucket_key = "health-event/src.zip"
    lambda_version = "${var.health_event_handler_version}"

    lambda_environment = "${var.health_event_handler_environment}"
}
