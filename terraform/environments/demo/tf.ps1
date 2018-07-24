Param(
  [string]$TF_SRC,
  [string]$TF_COMMAND,
  [string]$TF_COMMAND_ARGS
)

$ErrorActionPreference = "Stop"

Write-Output $TF_SRC

$WORKDIR=".\.workspace"
if (Test-Path $WORKDIR)
{
  rm  $WORKDIR -r -fo
}

mkdir $WORKDIR
cp *.tf $WORKDIR
cp ..\common\terraform.tfvars $WORKDIR
cp ..\..\src\$TF_SRC\*.tf $WORKDIR

$WORKDIR=$(Resolve-Path ".\.workspace").Path
Push-Location $WORKDIR
terraform init
powershell -Command "$env:AWS_PROFILE=$Env:AWS_PROFILE; Set-Location $WORKDIR; terraform $TF_COMMAND $TF_COMMAND_ARGS"
Pop-Location

rm $WORKDIR -r -fo