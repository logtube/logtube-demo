FROM alpine:3.9

# add basic packages
RUN apk add --no-cache tzdata ca-certificates openjdk8-jre openssl wget tomcat-native

# change timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && echo $TZ > /etc/TZ

# change locale to zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8

# add tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.40
ENV TOMCAT_SHA512 5bdea5414713c9ba39e226f062701fa14998b1a798c9750f956a0f59b5edabb8d83af9ec9f81cf9f47fa92c21b560c9b2be1b543d0bd8f1b49579b69101d3a8f
ENV TOMCAT_TGZ_URL https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN wget -O tomcat.tar.gz $TOMCAT_TGZ_URL && \
    echo "$TOMCAT_SHA512 *tomcat.tar.gz" | sha512sum -c - && \
    tar xvf tomcat.tar.gz --strip-components=1 && \
    rm -rf bin/*.bat && \
    rm -rf webapps/* && \
    rm tomcat.tar.gz*

ADD target/logtubed-demo-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]
