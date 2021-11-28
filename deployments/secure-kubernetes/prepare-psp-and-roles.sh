#!/bin/bash

echo "Preparing psp and roles $DUDEMO_KUBE_NAMESPACE"

envsubst < user-role.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1
envsubst < user-role-binding-template.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1
envsubst < psp.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1
envsubst < psp-role.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1
envsubst < psp-role-binding-template.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE apply -f - || exit 1
