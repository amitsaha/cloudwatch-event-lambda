#!/usr/bin/env bash
set -ex

# Create a .zip of src
pushd src
zip -r ../src.zip *
popd

aws s3 cp src.zip s3://aws-health-notif-demo-lambda-artifacts/ec2-state-change/src.zip
version=$(aws s3api head-object --bucket aws-health-notif-demo-lambda-artifacts --key ec2-state-change/src.zip)
version=$(echo $version | python -c 'import json,sys; obj=json.load(sys.stdin); print(obj["VersionId"])')

# Deploy to demo environment
pushd ../../terraform/environments/demo
bash tf.bash cloudwatch_event_handlers apply -var ec2_state_change_handler_version=$version \
    -target=aws_lambda_function.ec2_state_change \
    -target=aws_lambda_permission.ec2_state_change_cloudwatch \
    -target=aws_cloudwatch_event_target.ec2_state_change \
    -target=aws_iam_role_policy.ec2_state_change_lambda_cloudwatch_logging
popd
