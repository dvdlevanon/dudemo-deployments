#!/bin/bash

set -o pipefail

export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/dudemo-user/dudemo-user.crt --client-key $(pwd)/users/dudemo-user/dudemo-user.key -n dudemo-namespace"

pushd ../kubernetes || exit 1
./delete.sh || exit 1
popd || exit 1

kubectl -n dudemo-namespace delete -f user-role-binding.yaml
kubectl -n dudemo-namespace delete -f user-role.yaml
kubectl -n dudemo-namespace delete -f psp.yaml
kubectl -n dudemo-namespace delete -f psp-role.yaml
kubectl -n dudemo-namespace delete -f psp-role-binding.yaml
kubectl delete -f namespace.yaml
kubectl delete csr dudemo-user
