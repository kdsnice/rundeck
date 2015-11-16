FROM centos:centos7

MAINTAINER Dmitry Karanfilov

LABEL Description="Base RUNDECK image" Version="1.0"

ENV MYSQL_SERVER=mysql
ENV MYSQL_DATABASE=rundeck
ENV MYSQL_USER=rundeckuser
ENV MYSQL_PASSWORD=rundeckpassword
ENV SERVERURL=http://nicecodh.cloudapp.net
ENV SERVERPORT=80

RUN rpm -Uvh http://repo.rundeck.org/latest.rpm && \
        yum -y update && \
        yum -y install java-1.8.0-openjdk rundeck openssh-clients && \
        yum -y clean all

RUN sed -i.bak '/dataSource.url/d' /etc/rundeck/rundeck-config.properties && \
	sed -i.bak '/grails.serverURL/d' /etc/rundeck/rundeck-config.properties && \
	echo "grails.serverURL=$SERVERURL:$SERVERPORT" >> /etc/rundeck/rundeck-config.properties && \
	echo "dataSource.url = jdbc:mysql://$MYSQL_SERVER/$MYSQL_DATABASE?autoReconnect=true" >> /etc/rundeck/rundeck-config.properties && \
	echo "dataSource.username=$MYSQL_USER" >> /etc/rundeck/rundeck-config.properties && \
	echo "dataSource.password=$MYSQL_PASSWORD" >> /etc/rundeck/rundeck-config.properties

CMD source /etc/rundeck/profile && \
    ${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}

EXPOSE 4440
EXPOSE 4443
VOLUME /etc/rundeck
VOLUME /var/rundeck
