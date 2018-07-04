resource aws_s3_bucket lambda_artifacts {
  bucket = "aws-health-notif-demo-lambda-artifacts"
  acl    = "private"

  versioning {
    enabled = true
  }
}
