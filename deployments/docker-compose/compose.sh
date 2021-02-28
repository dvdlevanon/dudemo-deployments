#!/bin/bash

docker-compose -p "dudemo" "$@" || exit 1
