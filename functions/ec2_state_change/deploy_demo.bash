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
terraform init
terraform apply \
    -var aws_region=ap-southeast-2 \
    -var ec2_state_change_handler_version=$version \
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_lambda_function.lambda \
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_cloudwatch_event_rule.rule \
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_cloudwatch_event_target.target \
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_iam_role_policy.lambda_cloudwatch_logging \
    -target=module.ec2_state_change_handler.module.ec2_state_change_handler.aws_lambda_permission.cloudwatch_lambda_execution
popd
