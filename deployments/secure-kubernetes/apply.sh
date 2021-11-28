#!/bin/bash

source common.sh

set -o pipefail

if ! minikube addons list | grep pod-security-policy | grep enabled > /dev/null; then
  echo "The addon pod-security-policy should be enabled in minikube, please start it with the following command"
  echo "  minikube start --extra-config=apiserver.enable-admission-plugins=PodSecurityPolicy --addons=pod-security-policy"
  exit 1
fi

./prepare-user-and-namespace.sh
./prepare-psp-and-roles.sh
./deploy-app.sh
