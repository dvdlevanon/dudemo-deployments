#!/bin/bash

source common.sh

if ! minikube addons list | grep pod-security-policy | grep enabled > /dev/null; then
  echo "The addon pod-security-policy should be enabled in minikube, please start it with the following command"
  echo "  minikube start --extra-config=apiserver.enable-admission-plugins=PodSecurityPolicy --addons=pod-security-policy"
  exit 1
fi

mkdir -p users/$DUDEMO_KUBE_USER || exit 1

if ! kubectl get csr $DUDEMO_KUBE_USER >/dev/null 2>&1; then
  echo "Creating kubernetes user $DUDEMO_KUBE_USER"
  
  openssl genrsa -out "users/$DUDEMO_KUBE_USER/user.key" 2048 || exit 1
  openssl req -new -key "users/$DUDEMO_KUBE_USER/user.key" -out "users/$DUDEMO_KUBE_USER/user.csr" -subj "/CN=$DUDEMO_KUBE_USER/O=$DUDEMO_KUBE_USER" || exit 1

  export CSR_BASE64=$(cat "users/$DUDEMO_KUBE_USER/user.csr" | base64 | tr -d "\n")
  envsubst < csr-template.yaml | kubectl apply -f - || exit 1

  kubectl certificate approve $DUDEMO_KUBE_USER || exit 1
  kubectl get csr $DUDEMO_KUBE_USER -o jsonpath='{.status.certificate}'| base64 -d > "users/$DUDEMO_KUBE_USER/user.crt" || exit 1
else
  echo "User $DUDEMO_KUBE_USER already exists"
fi

echo "Creating namespace $DUDEMO_KUBE_NAMESPACE"
envsubst < namespace-template.yaml | kubectl apply -f - || exit 1