#!/bin/bash

[ -z "$DUDEMO_SERVER_MYSQL_HOST" ] && export DUDEMO_SERVER_MYSQL_HOST=localhost
[ -z "$DUDEMO_SERVER_MYSQL_USER" ] && export DUDEMO_SERVER_MYSQL_USER=david
[ -z "$DUDEMO_SERVER_MYSQL_PASS" ] && export DUDEMO_SERVER_MYSQL_PASS=123456
[ -z "$DUDEMO_SERVER_MYSQL_DB" ] && export DUDEMO_SERVER_MYSQL_DB=test
[ -z "$DUDEMO_SERVER_PORT" ] && export DUDEMO_SERVER_PORT=9090

python3 dudemo-server.py
