# cloudwatch-event-lambda

Code repository for the article [CloudWatch Event Notifications Using AWS Lambda](https://blog.codeship.com/cloudwatch-event-notifications-using-aws-lambda/)


# Deployment scripts

Before you can run the deployment, you would need to create the lambda artifacts S3 bucket. Please see `functions/infrastructure`
directory for a script.

The deployment scripts have been renamed `deploy_demo.bash` and `deploy_demo.ps1` for each function.

# Teraform source

The article was out of scope for discussing the details of the terraform source structure I adopted. I wrote this
[blog post](https://echorand.me/managing-aws-lambda-functions-from-start-to-finish-with-terraform.html) on the topic.

