#!/bin/bash

istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system
kubectl label namespace default istio-injection-

pushd ../kubernetes || exit 1
./delete.sh
popd || exit 1
