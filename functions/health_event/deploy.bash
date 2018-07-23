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
bash tf.bash cloudwatch_event_handlers apply \
    -var health_event_notify_handler_version=$version \
    -var health_event_webhook_url=$HEALTH_EVENT_WEBHOOK_URL \
    -target=aws_lambda_function.health_event \
    -target=aws_lambda_permission.health_event_cloudwatch \
    -target=aws_cloudwatch_event_target.health_event \
    -target=aws_iam_role_policy.health_event_lambda_cloudwatch_logging
popd
