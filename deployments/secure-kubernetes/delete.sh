#!/bin/bash

source common.sh

set -o pipefail

./delete-app.sh
./delete-psp-and-roles.sh
./delete-user-and-namespace.sh
