variable "aws_region" {
  type = "string"
}

variable "lambda_artifacts_bucket_name" {
  type = "string"
}

variable "aws_health_event_handler_lambda_version" {
    type = "string"
    default = ""
}

variable "ec2_state_change_handler_lambda_version" {
    type = "string"
    default = ""
}
