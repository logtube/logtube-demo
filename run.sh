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

# build image for stress
cd stress && \
    go build -o stress && \
    docker build -t stress . && \
    cd ..

# build image for filebeat
cd filebeat && \
    docker build -t filebeat . && \
    cd ..

# create logtubed <- elasticsearch
docker run -d --name logtubed -v logs-central:/data/xlogd_local --link elasticsearch logtubed

sleep 10

# create app <- logtubed
docker run -d --name app -v logs-app:/usr/local/tomcat/logs --link logtubed app

sleep 10

# create filebeat <- logtubed
docker run -d --name filebeat -v logs-app:/var/www/logs --link logtubed filebeat

sleep 10

# create stress

docker run -d --name stress --link app stress

# print logs
echo "========================================"
echo "=             = Result =               ="
echo "========================================"
echo
echo "========================================"
echo "=       = ElasticSearch Logs =         ="
echo "========================================"

edocker logs elasticsearch

echo "========================================"
echo "=          = Logtube Logs =            ="
echo "========================================"

docker logs logtubed

echo "========================================"
echo "=            = App Logs =              ="
echo "========================================"

docker logs app

echo "========================================"
echo "=          = Filebeat Logs =           ="
echo "========================================"

docker logs filebeat

echo "========================================"
echo "=           = Stress Logs =            ="
echo "========================================"

docker logs stress
