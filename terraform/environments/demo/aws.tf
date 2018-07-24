variable "aws_region" {
  type = "string"
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
}
