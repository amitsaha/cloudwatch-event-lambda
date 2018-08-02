$ErrorActionPreference = "Stop"

if (-not (Test-Path env:WEBHOOK_URL))
{
    Write-Error "WEBHOOK_URL environment variable not defined"
}

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

# Deploy to demo environment
Push-Location ..\..\terraform\environments/demo
terraform init

# I create a terraform map and save it to a file since I just couldn't come up with a way to
# pass a terraform map via `-var` after many many hours. 
# You can also see that I specify ASCII encoding, since powershell on Windows writes UTF8 with BOM
# encoding, which terraform doesn't like.
# This file is .gitignored, plus it is removed after terraform runs
$environment_map='health_event_handler_lambda_environment = {WEBHOOK_URL = "${Env:WEBHOOK_URL}"}'
$ExecutionContext.InvokeCommand.ExpandString($environment_map) | Out-File .\secrets.tfvars -Encoding ASCII
$cmd='terraform apply -var aws_region=ap-southeast-2 -var health_event_notify_handler_version="${version}" -var-file="secrets.tfvars" -target=''module.health_event_handler.module.health_event_handler.aws_lambda_function.lambda'' -target=''module.health_event_handler.module.health_event_handler.aws_cloudwatch_event_rule.rule'' -target=''module.health_event_handler.module.health_event_handler.aws_cloudwatch_event_target.target'' -target=''module.health_event_handler.module.health_event_handler.aws_iam_role_policy.lambda_cloudwatch_logging'' -target=''module.health_event_handler.module.health_event_handler.aws_lambda_permission.cloudwatch_lambda_execution'''
$cmd = $ExecutionContext.InvokeCommand.ExpandString($cmd)
iex $cmd

rm secrets.tfvars

Pop-Location
