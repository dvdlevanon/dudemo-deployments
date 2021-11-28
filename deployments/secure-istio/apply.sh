#!/bin/bash

source common.sh

set -o pipefail

if ! minikube addons list | grep pod-security-policy | grep enabled > /dev/null; then
  echo "The addon pod-security-policy should be enabled in minikube, please start it with the following command"
  echo "  minikube start --extra-config=apiserver.enable-admission-plugins=PodSecurityPolicy --addons=pod-security-policy"
  exit 1
fi

source common.sh

pushd ../secure-kubernetes || exit 1
./prepare-user-and-namespace.sh || exit 1
./prepare-psp-and-roles.sh || exit 1
popd || exit 1

export MINIKUBE_CMD="minikube -n $DUDEMO_KUBE_NAMESPACE"
export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/$DUDEMO_KUBE_USER/user.crt --client-key $(pwd)/users/$DUDEMO_KUBE_USER/user.key -n $DUDEMO_KUBE_NAMESPACE"
pushd ../istio || exit 1
./apply.sh || exit 1
popd || exit 1

pushd ../secure-kubernetes || exit 1
./deploy-app.sh || exit 1
popd || exit 1

export INGRESS_HOST=$(minikube ip)
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export INGRESS_URL=http://$INGRESS_HOST:$INGRESS_PORT

echo $INGRESS_URL
