resource "aws_dynamodb_table" "aws-health-notif-demo-tfstate" {

  name = "aws-health-notif-demo-tfstate"
  hash_key = "LockID"
  read_capacity = 1
  write_capacity = 1
 
  attribute {
    name = "LockID"
    type = "S"
  }
}
