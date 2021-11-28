#!/bin/bash

source common.sh

./prepare-user-and-namespace.sh

export MINIKUBE_CMD="minikube -n $DUDEMO_KUBE_NAMESPACE"
export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/$DUDEMO_KUBE_USER/user.crt --client-key $(pwd)/users/$DUDEMO_KUBE_USER/user.key -n $DUDEMO_KUBE_NAMESPACE"

echo "Preparing namespace and roles $DUDEMO_KUBE_NAMESPACE"

envsubst < user-role.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1
envsubst < user-role-binding-template.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1
envsubst < psp.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1
envsubst < psp-role.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1
envsubst < psp-role-binding-template.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1

echo "Deploying dudemo application"

pushd ../kubernetes || exit
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
