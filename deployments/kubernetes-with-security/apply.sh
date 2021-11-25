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

export MINIKUBE_CMD="minikube -n $DUDEMO_KUBE_NAMESPACE"
export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/$DUDEMO_KUBE_USER/user.crt --client-key $(pwd)/users/$DUDEMO_KUBE_USER/user.key -n $DUDEMO_KUBE_NAMESPACE"

echo "Preparing namespace and roles $DUDEMO_KUBE_NAMESPACE"

envsubst < namespace-template.yaml | kubectl apply -f - || exit 1
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
