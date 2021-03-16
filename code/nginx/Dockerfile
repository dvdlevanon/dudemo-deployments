FROM nginx:latest

RUN apt-get update && apt-get install -y libbpf-dev libelf-dev

COPY dudemo.crt /etc/ssl/dudemo.crt
COPY dudemo.key /etc/ssl/private/dudemo.key
COPY dudemo-server.conf /etc/nginx/templates/dudemo-server.conf.template
