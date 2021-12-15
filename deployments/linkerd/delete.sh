#!/bin/bash

[ -z "$DUDEMO_KUBE_NAMESPACE" ] && export DUDEMO_KUBE_NAMESPACE="default"

pushd ../kubernetes || exit 1
./delete.sh
popd || exit 1
