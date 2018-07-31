variable "cloudwatch_event_rule_name" {
  type = "string"
}

variable "cloudwatch_event_rule_description" {
  type = "string"
}

variable "cloudwatch_event_rule_pattern" {
  type = "string"
}


variable "lambda_iam_role_name" {
  type = "string"
}

variable "lambda_function_name" {
  type = "string"
}

variable "lambda_handler" {
  type = "string"
}

variable "lambda_runtime" {
  type = "string"
}

variable "lambda_artifacts_bucket_name" {
  type = "string"
}

variable "lambda_artifacts_bucket_key" {
  type = "string"
}

variable "lambda_version" {
  type    = "string"
}

variable "lambda_environment" {
  type    = "map"
  default = {}
}
