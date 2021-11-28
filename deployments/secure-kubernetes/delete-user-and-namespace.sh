#!/bin/bash

envsubst < namespace-template.yaml | kubectl delete -f -
kubectl delete csr $DUDEMO_KUBE_USER
