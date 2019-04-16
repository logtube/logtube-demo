#!/bin/sh

set -e
set -u

# create volumes
docker volume create logs-central
docker volume create logs-app

# create elasticsearch
docker run -d --name elasticsearch -e "discovery.type=single-node" elasticsearch:6.7.1

# build image for app
cd app && \
    mvn -DskipTests=true package && \
    docker build -t app . && \
    cd ..

# build image for logtubed
cd logtubed && \
    go get -u github.com/logtube/logtubed && \
    go build -o logtubed github.com/logtube/logtubed && \
    docker build -t logtubed . && \
    cd ..

# build image for filebeat
cd filebeat && \
    docker build -t filebeat . && \
    cd ..

# create logtubed <- elasticsearch
docker run -d --name logtubed -v logs-central:/data/xlogd_local --link elasticsearch logtubed

# create app <- logtubed
docker run -d --name app -v logs-app:/usr/local/tomcat/logs --link logtubed app

# create filebeat <- logtubed
docker run -d --name filebeat -v logs-app:/var/www/logs --link logtubed filebeat

# sleep 10
sleep 10

# print logs
docker logs elasticsearch

docker logs logtubed

docker logs app

docker logs filebeat
