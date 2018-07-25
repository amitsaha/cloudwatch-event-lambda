variable "lambda_artifacts_bucket_name" {
    type = "string"
}

module "lambda_artifacts" {

  source = "../deployment_artifacts"
  lambda_artifacts_bucket_name = "${var.lambda_artifacts_bucket_name}"
}
