#!/bin/sh

set -e
set -u

# create volumes
docker volume create logs-central
docker volume create logs-app

# create elasticsearch
docker pull elasticsearch:6.7.1 > /dev/null
docker pull alpine:3.9 > /dev/null
docker pull centos:7 > /dev/null

docker run -d --name elasticsearch -e "discovery.type=single-node" elasticsearch:6.7.1

# build image for app
cd app && \
    mvn -DskipTests=true package > /dev/null && \
    docker build -t app . > /dev/null && \
    cd ..

# build image for logtubed
cd logtubed && \
    go get -u github.com/logtube/logtubed > /dev/null && \
    go build -o logtubed github.com/logtube/logtubed > /dev/null && \
    docker build -t logtubed . > /dev/null && \
    cd ..

# build image for stress
cd stress && \
    go build -o stress > /dev/null && \
    docker build -t stress . > /dev/null && \
    cd ..

# build image for filebeat
cd filebeat && \
    docker build -t filebeat . > /dev/null && \
    cd ..

# create logtubed <- elasticsearch
docker run -d --name logtubed -v logs-central:/data/xlogd_local --link elasticsearch logtubed

sleep 10

# create app <- logtubed
docker run -d --name app -v logs-app:/usr/local/tomcat/logs --link logtubed app

sleep 10

# create filebeat <- logtubed
docker run -d --name filebeat -v logs-app:/usr/local/tomcat/logs --link logtubed filebeat

sleep 10

# run stress

docker run -ti --name stress --link app stress &> /dev/null

sleep 10

# print logs
echo "========================================"
echo "=             = Result =               ="
echo "========================================"
echo
echo "========================================"
echo "=       = ElasticSearch Logs =         ="
echo "========================================"

docker logs elasticsearch

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

echo "========================================"
echo "=         = App Log Files =            ="
echo "========================================"

docker run -ti -v logs-app:/usr/local/tomcat/logs alpine:3.9 find /usr/local/tomcat/logs

echo "========================================"
echo "=        = Central Log Files =         ="
echo "========================================"

docker run -ti -v logs-central:/var/log/logtubed-logs alpine:3.9 find /var/log/logtubed-logs
