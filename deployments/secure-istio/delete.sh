#!/bin/bash

source common.sh

set -o pipefail

pushd ../secure-kubernetes || exit 1
./delete.sh || exit 1
popd || exit 1

pushd ../istio || exit 1
./delete.sh || exit 1
popd || exit 1
