#!/bin/bash

[ -z "$KUBECTL_CMD" ] && KUBECTL_CMD=kubectl

$KUBECTL_CMD delete -f monitor-deployment.yaml
$KUBECTL_CMD delete -f nginx-deployment.yaml
$KUBECTL_CMD delete -f server-deployment.yaml
$KUBECTL_CMD delete -f db-deployment.yaml
$KUBECTL_CMD delete configmap dudemo-config
$KUBECTL_CMD delete -f secret.yaml