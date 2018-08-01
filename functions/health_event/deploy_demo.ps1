$ErrorActionPreference = "Stop"

Push-Location src
Compress-Archive -Path * -Update -DestinationPath ..\src.zip
Pop-Location

aws s3 cp src.zip s3://aws-health-notif-demo-lambda-artifacts//health-event/src.zip
if ($LastExitCode -ne 0)
{
    exit $LastExitCode
}
$output=aws s3api head-object --bucket aws-health-notif-demo-lambda-artifacts --key /health-event/src.zip | ConvertFrom-Json
if ($LastExitCode -ne 0)
{
    exit $LastExitCode
}
$version=$output.VersionId
$WEBHOOK_URL = "http://www.foo.com"
# Deploy to demo environment
Push-Location ..\..\terraform\environments/demo
terraform init
$environment_map='{health_event_webhook_url = "${Env:WEBHOOK_URL}"}'
$environment_map = $ExecutionContext.InvokeCommand.ExpandString($environment_map)
echo $environment_map

# FIXME: doesn't work

$cmd='terraform apply -var aws_region=ap-southeast-2 -var health_event_notify_handler_version="${version}" -var health_event_handler_lambda_environment=''${environment_map}'' -target=''module.health_event_handler.module.health_event_handler.aws_lambda_function.lambda'' -target=''module.health_event_handler.module.health_event_handler.aws_cloudwatch_event_rule.rule'' -target=''module.health_event_handler.module.health_event_handler.aws_cloudwatch_event_target.target'' -target=''module.health_event_handler.module.health_event_handler.aws_iam_role_policy.lambda_cloudwatch_logging'' -target=''module.health_event_handler.module.health_event_handler.aws_lambda_permission.cloudwatch_lambda_execution'''
$cmd = $ExecutionContext.InvokeCommand.ExpandString($cmd)
echo $cmd
iex $cmd
Pop-Location
