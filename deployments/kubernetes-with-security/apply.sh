#!/bin/bash

# minikube start --extra-config=apiserver.enable-admission-plugins=PodSecurityPolicy --addons=pod-security-policy || exit 1

mkdir -p users/dudemo-user || exit 1

if ! $KUBECTL_CMD get csr dudemo-user >/dev/null 2>&1; then
	openssl genrsa -out "users/dudemo-user/dudemo-user.key" 2048 || exit 1
	openssl req -new -key "users/dudemo-user/dudemo-user.key" -out "users/dudemo-user/dudemo-user.csr" -subj "/CN=dudemo-user/O=dudemo-user" || exit 1

	export CSR_BASE64=$(cat "users/dudemo-user/dudemo-user.csr" | base64 | tr -d "\n")
	export CSR_USERNAME=dudemo-user
	envsubst < csr-template.yaml > users/dudemo-user/csr.yaml || exit 1
	kubectl apply -f users/dudemo-user/csr.yaml || exit 1

	kubectl certificate approve dudemo-user || exit 1
	kubectl get csr dudemo-user -o jsonpath='{.status.certificate}'| base64 -d > "users/dudemo-user/dudemo-user.crt" || exit 1
fi

export MINIKUBE_CMD="minikube -n dudemo-namespace"
export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/dudemo-user/dudemo-user.crt --client-key $(pwd)/users/dudemo-user/dudemo-user.key -n dudemo-namespace"

kubectl apply -f namespace.yaml || exit 1
kubectl -n dudemo-namespace apply -f user-role.yaml || exit 1
kubectl -n dudemo-namespace apply -f user-role-binding.yaml || exit 1
kubectl -n dudemo-namespace apply -f psp.yaml || exit 1
kubectl -n dudemo-namespace apply -f psp-role.yaml || exit 1
kubectl -n dudemo-namespace apply -f psp-role-binding.yaml || exit 1

pushd ../kubernetes || exit
./apply.sh || exit 1
popd || exit 1

echo $KUBECTL_CMD
