module "lambda_artifacts" {

  source = "../../../modules/lambda_deployment_artifacts"
  lambda_artifacts_bucket_name = "aws-health-notif-demo-lambda-artifacts"  
}
