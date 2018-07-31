#!/usr/bin/env bash
set -e

pushd src
zip -r ../src.zip *
popd

aws s3 cp src.zip s3://aws-health-notif-demo-lambda-artifacts/health-event/src.zip
version=$(aws s3api head-object --bucket aws-health-notif-demo-lambda-artifacts --key health-event/src.zip)
version=$(echo $version | python -c 'import json,sys; obj=json.load(sys.stdin); print(obj["VersionId"])')

if [ -z "$HEALTH_EVENT_WEBHOOK_URL" ]; then
    echo "HEALTH_EVENT_WEBHOOK_URL not specified"
    exit 1
fi


# Deploy to demo environment
pushd ../../terraform/environments/demo
terraform init
terraform apply \
    -var aws_region=ap-southeast-2 \
    -var health_event_notify_handler_version=$version \
    -var health_event_handler_environment="{ health_event_webhook_url=$HEALTH_EVENT_WEBHOOK_URL}" \
    -target=module.health_event_handler.module.health_event_handler.aws_lambda_function.lambda \
    -target=module.health_event_handler.module.health_event_handler.aws_cloudwatch_event_rule.rule \
    -target=module.health_event_handler.module.health_event_handler.aws_cloudwatch_event_target.target \
    -target=module.health_event_handler.module.health_event_handler.aws_iam_role_policy.lambda_cloudwatch_logging \
    -target=module.health_event_handler.module.health_event_handler.aws_lambda_permission.cloudwatch_lambda_execution
popd
