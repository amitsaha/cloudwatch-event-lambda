variable "aws_region" {
  type = "string"
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
}

module "lambda_artifacts" {
  source = "./lamba_deployment_artifacts"
}

module "ec2_state_change_handler" {
  source = "./ec2_state_change_handler"
}

module "health_event_handler" {
  source = "./health_event_handler"
}
