#!/bin/bash

set -o pipefail

[ -z "$DUDEMO_KUBE_NAMESPACE" ] && export DUDEMO_KUBE_NAMESPACE="default"

pushd ../kubernetes || exit 1
./apply.sh || exit 1
popd || exit 1

if ! kubectl describe namespace linkerd >/dev/null; then
	linkerd install | kubectl apply -f - || exit 1
fi

kubectl get -n default deploy -o yaml | linkerd inject - | kubectl apply -f - || exit 1
