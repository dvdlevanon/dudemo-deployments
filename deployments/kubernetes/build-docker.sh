#!/bin/bash

if [ "$1" != "no-minikube" ]; then
	eval $(minikube -p minikube docker-env)
fi

pushd ../.. || exit 1

pushd code/server || exit 1
docker build -t dudemo-server . || exit 1
popd || exit 1

pushd code/nginx || exit 1
docker build -t dudemo-nginx . || exit 1
popd || exit 1

pushd code/monitor || exit 1
docker build -t dudemo-monitor . || exit 1
popd || exit 1

popd
