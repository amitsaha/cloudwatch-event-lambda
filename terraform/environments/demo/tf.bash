#!//usr/bin/bash
set -ex

TF_SRC=$1
echo $TF_SRC

WORKDIR=$(mktemp -d)

cp {aws.tf,backend.tf} $WORKDIR/
cp ../../src/$TF_SRC/*.tf $WORKDIR/

pushd $WORKDIR
terraform init
terraform apply
popd

rm -r $WORKDIR
