#!/bin/bash 

export KUBECTL_CMD="kubectl --cluster minikube --client-certificate $(pwd)/users/dudemo-user/dudemo-user.crt --client-key $(pwd)/users/dudemo-user/dudemo-user.key -n dudemo-namespace"

$KUBECTL_CMD $@
