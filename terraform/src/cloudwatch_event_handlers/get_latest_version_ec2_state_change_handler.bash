#!/bin/bash

aws s3api head-object --bucket aws-health-notif-demo-lambda-artifacts --key cloudwatch-event-handler/src.zip 
