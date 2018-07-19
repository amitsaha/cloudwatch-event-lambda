#!/usr/bin/bash
set -ex

TF_SRC=$1
echo $TF_SRC

WORKDIR="./.workspace"
rm -rf $WORKDIR
mkdir $WORKDIR

cp *.tf $WORKDIR/
cp ../common/terraform.tfvars $WORKDIR/
cp ../../src/$TF_SRC/*.tf $WORKDIR/

pushd $WORKDIR
terraform init
terraform "${@:2}"
popd

rm -r $WORKDIR
