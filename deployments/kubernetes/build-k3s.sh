#!/bin/bash

./build-docker.sh no-minikube

docker image save dudemo-server -o /tmp/dudemo-server.tar.gz || exit 1
docker image save dudemo-nginx -o /tmp/dudemo-nginx.tar.gz || exit 1
docker image save dudemo-monitor -o /tmp/dudemo-monitor.tar.gz || exit 1

sudo k3s ctr image import /tmp/dudemo-server.tar.gz || exit 1
sudo k3s ctr image import /tmp/dudemo-nginx.tar.gz || exit 1
sudo k3s ctr image import /tmp/dudemo-monitor.tar.gz || exit 1
