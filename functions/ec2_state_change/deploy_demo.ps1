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

$version=$output.VersionId
# Deploy to demo environment
Push-Location ..\..\terraform\environments\demo
terraform init
terraform apply `
    -var aws_region=ap-southeast-2 `
    -var ec2_state_change_handler_version=$version `
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_lambda_function.lambda `
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_cloudwatch_event_rule.rule `
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_cloudwatch_event_target.target `
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_iam_role_policy.lambda_cloudwatch_logging `
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_lambda_permission.cloudwatch_lambda_execution
Pop-Location
