# Configure the AWS Provider
provider "aws" {
  region     = "ap-southeast-2"
}


resource aws_s3_bucket "tf_state" {
  bucket = "aws-health-notif-demo-tfstate"
  acl    = "private"

  versioning {
    enabled = true
  }
}
