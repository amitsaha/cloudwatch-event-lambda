terraform {
  backend "s3" {
    bucket         = "aws-health-notif-demo-tfstate"
    key            = "terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "aws-health-notif-demo-tfstate"
  }
}
