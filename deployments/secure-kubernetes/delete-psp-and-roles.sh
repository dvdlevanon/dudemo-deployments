#!/bin/bash

envsubst < user-role.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f -
envsubst < psp.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f -
envsubst < psp-role.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f -
envsubst < user-role-binding-template.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f -
envsubst < psp-role-binding-template.yaml | kubectl -n $DUDEMO_KUBE_NAMESPACE delete -f -
