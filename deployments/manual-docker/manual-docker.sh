#!/bin/bash

declare docker_network_name=dudemo-manual-network
declare dudemo_mysql_db=dudemo-db
declare dudemo_mysql_user=dudemo-user
declare dudemo_mysql_pass=123456
declare dudemo_server_port=9090
declare dudemo_nginx_port=4040

pushd ../.. || exit 1

pushd code/server || exit 1
docker build -t dudemo-manual-server . || exit 1
popd || exit 1

pushd code/nginx || exit 1
docker build -t dudemo-manual-nginx . || exit 1
popd || exit 1

pushd code/monitor || exit 1
docker build -t dudemo-manual-monitor . || exit 1
popd || exit 1

if ! docker network ls | grep "$docker_network_name"; then
	docker network create "$docker_network_name" || exit 1
fi

docker run -d --name "dudemo-manual-test" \
	-e "MYSQL_ROOT_PASSWORD=$dudemo_mysql_pass" \
	-e "MYSQL_DATABASE=$dudemo_mysql_db" \
	-e "MYSQL_USER=$dudemo_mysql_user" \
	-e "MYSQL_PASSWORD=$dudemo_mysql_pass" \
	--network="$docker_network_name" \
	-t mysql || exit 1

docker run -d --name "dudemo-manual-server" \
	-e "DUDEMO_SERVER_MYSQL_HOST=dudemo-manual-test" \
	-e "DUDEMO_SERVER_MYSQL_USER=$dudemo_mysql_user" \
	-e "DUDEMO_SERVER_MYSQL_PASS=$dudemo_mysql_pass" \
	-e "DUDEMO_SERVER_MYSQL_DB=$dudemo_mysql_db" \
	-e "DUDEMO_SERVER_PORT=$dudemo_server_port" \
	--network="$docker_network_name" \
	-t dudemo-manual-server || exit 1

docker run -d \
	-p "$dudemo_nginx_port:$dudemo_nginx_port" \
	-e "DUDEMO_SERVER_PORT=$dudemo_server_port" \
	-e "NGINX_PORT=$dudemo_nginx_port" \
	-e "DUDEMO_SERVER_HOST=dudemo-manual-server" \
	--network="$docker_network_name" \
	-t dudemo-manual-nginx || exit 1

docker run -d --privileged --network host -i dudemo-manual-monitor || exit 1

popd 
