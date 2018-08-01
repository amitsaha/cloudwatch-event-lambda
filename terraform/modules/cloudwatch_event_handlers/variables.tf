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

# We neeed a default non-empty map here since terraform doesn't allow null/undefined objects
# Terraform 0.12 should eliminate the need to do this
# https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements
variable "lambda_environment" {
  type    = "map"
  default = {
    "DUMMY" = 1
  }
}
