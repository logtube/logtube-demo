#!/bin/sh

set -e
set -u

# recreate volumes
docker volume create logs-central
docker volume create logs-app

# recreate elasticsearch
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

# recreate logtubed
docker run -d --name logtubed -v logs-central:/data/xlogd_local --link elasticsearch logtubed
