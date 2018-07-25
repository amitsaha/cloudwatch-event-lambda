Param(
  [string]$TF_SRC,
  [string]$TF_COMMAND,
  [string]$TF_COMMAND_ARGS
)

$ErrorActionPreference = "Stop"

terraform init
terraform $TF_COMMAND $TF_COMMAND_ARGS
Pop-Location