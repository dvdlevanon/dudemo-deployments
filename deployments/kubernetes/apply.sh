#!/bin/bash

kubectl apply -f secret.yaml || exit 1

if ! kubectl get configmaps | grep dudemo-config; then
	kubectl create configmap dudemo-config --from-env-file=dudemo-config.properties || exit 1
fi

kubectl apply -f db-deployment.yaml || exit 1
kubectl apply -f server-deployment.yaml || exit 1
kubectl apply -f nginx-deployment.yaml || exit 1
kubectl apply -f monitor-deployment.yaml || exit 1

minikube service --url dudemo-nginx
