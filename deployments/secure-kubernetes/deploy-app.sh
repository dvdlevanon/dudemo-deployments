#!/bin/bash

echo "Deploying dudemo application"

export MINIKUBE_CMD="minikube -n $DUDEMO_KUBE_NAMESPACE"
export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/$DUDEMO_KUBE_USER/user.crt --client-key $(pwd)/users/$DUDEMO_KUBE_USER/user.key -n $DUDEMO_KUBE_NAMESPACE"

pushd ../kubernetes || exit 1
./apply.sh || exit 1
popd || exit 1

kubectl config set-credentials $DUDEMO_KUBE_USER \
  --client-key $(pwd)/users/$DUDEMO_KUBE_USER/user.key \
  --client-certificate $(pwd)/users/$DUDEMO_KUBE_USER/user.crt

kubectl config set-context $DUDEMO_KUBE_USER \
  --cluster=minikube \
  --namespace=$DUDEMO_KUBE_NAMESPACE \
  --user=$DUDEMO_KUBE_USER

echo $KUBECTL_CMD
