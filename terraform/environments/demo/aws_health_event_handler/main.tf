module "aws_health_event_handler" {

    source = "../../../modules/cloudwatch_event_handlers"

    cloudwatch_event_rule_name = "health-event"
    cloudwatch_event_rule_description = "Invoke a lambda function when there is a scheduled health event"
    cloudwatch_event_rule_pattern = <<PATTERN
{
  "source": [ "aws.health" ],
  "detail-type": [ "AWS Health Event" ]
}
PATTERN
}
     lambda_iam_role_name = "health_event_lambda"
     lambda_function_name = "health_event"
     lambda_handler = "main.handler"
     lambda_runtime = "python3.6"

     lambda_artifacts_bucket_name = "aws-health-notif-demo-lambda-artifacts"
     lambda_artifacts_bucket_key = "health-event/src.zip"
     lambda_version = ""
}