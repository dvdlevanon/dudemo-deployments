#!/bin/bash

[ -z "$DUDEMO_KUBE_NAMESPACE" ] && export DUDEMO_KUBE_NAMESPACE="default"

istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system
kubectl label namespace "$DUDEMO_KUBE_NAMESPACE" istio-injection-

pushd ../kubernetes || exit 1
./delete.sh
popd || exit 1
