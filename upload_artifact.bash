#!/usr/bin/env bash

# Create a .zip of src
pushd src
zip -r ../src.zip *
popd

aws s3 cp src.zip s3://aws-health-notif-demo-lambda-artifacts/cloudwatch-event-handler/src.zip
