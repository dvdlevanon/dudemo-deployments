#!/bin/bash

source common.sh

set -o pipefail

export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/$DUDEMO_KUBE_USER/user.crt --client-key $(pwd)/users/$DUDEMO_KUBE_USER/user.key -n $DUDEMO_KUBE_NAMESPACE"

pushd ../kubernetes || exit 1
./delete.sh || exit 1
popd || exit 1

kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f user-role.yaml
kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f psp.yaml
kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f psp-role.yaml
envsubst < user-role-binding-template.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f -
envsubst < psp-role-binding-template.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f -
envsubst < namespace-template.yaml | kubectl delete -f -
kubectl delete csr $DUDEMO_KUBE_USER
