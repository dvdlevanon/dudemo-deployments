#!/bin/bash

istioctl install --set profile=demo -y || exit 1
kubectl label namespace default --overwrite istio-injection=enabled || exit 1

pushd ../kubernetes || exit 1
./apply.sh
popd || exit 1

kubectl apply -f istio-gateway.yaml || exit 1
kubectl apply -f istio-virtual-service.yaml || exit 1

export INGRESS_HOST=$(minikube ip)
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export INGRESS_URL=http://$INGRESS_HOST:$INGRESS_PORT
# minikube tunnel

echo $INGRESS_URL
