#!/usr/bin/env bash
set -ex

# Create a .zip of src
pushd src
zip -r ../src.zip *
popd

aws s3 cp src.zip s3://aws-health-notif-demo-lambda-artifacts/health-event/src.zip
version=$(aws s3api head-object --bucket aws-health-notif-demo-lambda-artifacts --key health-event/src.zip)
version=$(echo $version | python -c 'import json,sys; obj=json.load(sys.stdin); print(obj["VersionId"])')

# Deploy to demo environment
pushd ../../terraform/environments/demo
bash tf.bash cloudwatch_event_handlers apply -var health_event_handler_version=$version \
    -target=aws_lambda_function.health_event \
    -target=aws_lambda_permission.health_event_cloudwatch \
    -target=aws_cloudwatch_event_target.health_event \
    -target=aws_iam_role_policy.health_event_lambda_cloudwatch_logging
popd