#!/bin/bash

aws s3api head-object --bucket aws-health-notif-demo-lambda-artifacts --key health-event/src.zip 
