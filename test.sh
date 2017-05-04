#!/usr/bin/env bash

set -e

for it in cloudtrail/test/fixtures/minimal
do
  pushd "${it}"
  terraform get -update
  terraform validate
  terraform plan -out=tf-test-plan.out
  popd

done;