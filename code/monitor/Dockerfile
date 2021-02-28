FROM debian:buster

RUN apt-get update && apt-get install -y tcpdump

COPY dudemo-monitor.sh /entrypoint.sh

ENTRYPOINT "/entrypoint.sh" 
