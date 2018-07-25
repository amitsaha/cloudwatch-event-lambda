provider "aws" {
  region = "${var.aws_region}"
}

module "lambda_artifacts" {
  source = "../../modules/deployment_artifacts"
  lambda_artifacts_bucket_name = "${var.lambda_artifacts_bucket_name}"  
}

module "ec2_state_change_handler" {
  source = "../../modules/ec2_state_change_handler"
  lambda_artifacts_bucket_name = "${var.lambda_artifacts_bucket_name}"
  ec2_state_change_handler_version = "${var.ec2_state_change_handler_lambda_version}"
  
}

module "health_event_handler" {
  source = "../../modules/health_event_handler"
  lambda_artifacts_bucket_name = "${var.lambda_artifacts_bucket_name}"
  health_event_handler_version = "${var.aws_health_event_handler_lambda_version}"
}
