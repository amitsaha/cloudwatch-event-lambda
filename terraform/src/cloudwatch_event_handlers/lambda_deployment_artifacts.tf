resource aws_s3_bucket lambda_artifacts {
  bucket = "${var.lambda_artifacts_bucket_name}"
  acl    = "private"

  versioning {
    enabled = true
  }
}
