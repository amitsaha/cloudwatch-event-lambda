variable "lambda_artifacts_bucket_name" {
  type = "string"
}

variable "ec2_state_change_handler_version" {
  type    = "string"
  default = ""
}

variable "health_event_notify_handler_version" {
  type    = "string"
  default = ""
}
