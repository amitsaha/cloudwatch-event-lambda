Push-Location  ..\..\..\..\terraform\environments/demo
terraform init
terraform apply `
    -var aws_region=ap-southeast-2 `
    -target=module.lambda_artifacts.aws_s3_bucket.artifacts
Pop-Location
