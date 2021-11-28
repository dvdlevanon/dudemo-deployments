#!/bin/bash

export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/$DUDEMO_KUBE_USER/user.crt --client-key $(pwd)/users/$DUDEMO_KUBE_USER/user.key -n $DUDEMO_KUBE_NAMESPACE"

pushd ../kubernetes || exit 1
./delete.sh
popd || exit 1

kubectl config delete-user $DUDEMO_KUBE_USER
kubectl config delete-context $DUDEMO_KUBE_USER
