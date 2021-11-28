#!/bin/bash

[ -z "$DUDEMO_KUBE_NAMESPACE" ] && export DUDEMO_KUBE_NAMESPACE="default"

istioctl install --set profile=demo -y || exit 1
kubectl label namespace $DUDEMO_KUBE_NAMESPACE --overwrite istio-injection=enabled || exit 1

pushd ../kubernetes || exit 1
./apply.sh
popd || exit 1

envsubst < istio-gateway.yaml | kubectl apply -f - || exit 1
envsubst < istio-virtual-service.yaml | kubectl apply -f - || exit 1

export INGRESS_HOST=$(minikube ip)
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export INGRESS_URL=http://$INGRESS_HOST:$INGRESS_PORT

echo $INGRESS_URL
