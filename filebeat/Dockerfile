FROM centos:7

RUN yum -y install wget tar && \
    yum clean all

RUN mkdir -p /usr/local/filebeat

WORKDIR /usr/local/filebeat

ENV FILEBEAT_VERSION 6.3.1
ENV FILEBEAT_URL https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$FILEBEAT_VERSION-linux-x86_64.tar.gz

RUN wget -O filebeat.tar.gz $FILEBEAT_URL && \
    tar xvf filebeat.tar.gz --strip-components 1 && \
    rm -rf filebeat.tar.gz

ADD filebeat.yml /usr/local/filebeat/filebeat.yml

RUN chmod 644 filebeat.yml

CMD ["./filebeat", "run", "-e"]
