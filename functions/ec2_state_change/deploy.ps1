$ErrorActionPreference = "Stop"

Push-Location src
Compress-Archive -Path * -Update -DestinationPath ..\src.zip
Pop-Location

aws s3 cp src.zip s3://aws-health-notif-demo-lambda-artifacts/ec2-state-change/src.zip
if ($LastExitCode -ne 0)
{
    exit $LastExitCode
}
$output=aws s3api head-object --bucket aws-health-notif-demo-lambda-artifacts --key ec2-state-change/src.zip | ConvertFrom-Json
if ($LastExitCode -ne 0)
{
    exit $LastExitCode
}

# Deploy to demo environment
Push-Location ..\..\terraform\environments\demo
.\tf.ps1 cloudwatch_event_handlers apply -var aws_region=ap-southeast-2 -var ec2_state_change_handler_version=$($output.VersionId) -target=aws_lambda_function.ec2_state_change -target=aws_lambda_permission.ec2_state_change_cloudwatch -target=aws_cloudwatch_event_target.ec2_state_change -target=aws_iam_role_policy.ec2_state_change_lambda_cloudwatch_logging
Pop-Location