#!/bin/bash 

source common.sh

export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/$DUDEMO_KUBE_USER/user.crt --client-key $(pwd)/users/$DUDEMO_KUBE_USER/user.key -n $DUDEMO_KUBE_NAMESPACE"

$KUBECTL_CMD $@
