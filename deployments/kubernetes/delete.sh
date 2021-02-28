#!/bin/bash

kubectl delete -f monitor-deployment.yaml
kubectl delete -f nginx-deployment.yaml
kubectl delete -f server-deployment.yaml
kubectl delete -f db-deployment.yaml
kubectl delete configmap dudemo-config
kubectl delete -f secret.yaml