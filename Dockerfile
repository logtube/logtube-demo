FROM alpine:3.9

RUN apk add --no-cache docker go openjdk8 maven git build-base gcc

ADD . /workspace

WORKDIR /workspace

CMD ["/workspace/run.sh"]
