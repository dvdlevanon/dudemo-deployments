#!/bin/bash

[ -z "$KUBECTL_CMD" ] && export KUBECTL_CMD=kubectl
[ -z "$MINIKUBE_CMD" ] && export MINIKUBE_CMD=minikube

$KUBECTL_CMD apply -f secret.yaml || exit 1

if ! $KUBECTL_CMD get configmaps dudemo-config >/dev/null 2>&1; then
	$KUBECTL_CMD create configmap dudemo-config --from-env-file=dudemo-config.properties || exit 1
fi

$KUBECTL_CMD apply -f db-deployment.yaml || exit 1
$KUBECTL_CMD apply -f server-deployment.yaml || exit 1
$KUBECTL_CMD apply -f nginx-deployment.yaml || exit 1
$KUBECTL_CMD apply -f monitor-deployment.yaml || exit 1

$MINIKUBE_CMD service --url dudemo-nginx
