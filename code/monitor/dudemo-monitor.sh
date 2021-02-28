#!/bin/bash

[ -z "$DUDEMO_SERVER_PORT" ] && export DUDEMO_SERVER_PORT=9090

tcpdump -n -i any dst port 3306 or dst port "$DUDEMO_SERVER_PORT"
