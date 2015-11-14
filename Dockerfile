FROM centos:centos7

MAINTAINER Dmitry Karanfilov

LABEL Description="Base RUNDECK image" Version="1.0"

RUN rpm -Uvh http://repo.rundeck.org/latest.rpm && \
	yum -y update && \
	yum -y install java-1.8.0-openjdk rundeck openssh-clients && \
	yum -y clean all

CMD source /etc/rundeck/profile && \
    ${JAVA_HOME:-/usr}/bin/java ${RDECK_JVM} -cp ${BOOTSTRAP_CP} com.dtolabs.rundeck.RunServer /var/lib/rundeck ${RDECK_HTTP_PORT}

EXPOSE 4440
EXPOSE 4443
VOLUME /etc/rundeck
VOLUME /var/rundeck
