FROM ubuntu
MAINTAINER Matt Baldwin (baldwin@stackpointcloud.com)

RUN \
  apt-get update && apt-get install -y \
    ca-certificates \
    software-properties-common \
    python-django-tagging \
    python-simplejson \
    python-memcache \
    python-ldap \
    python-cairo \
    python-pysqlite2 \
    python-support \
    python-pip \
    gunicorn \
    supervisor \
    nginx-light \
    nodejs \
    git \
    curl \
    openjdk-7-jre \
    build-essential \
    python-dev && \
  curl -s -o /src/grafana-1.8.1.tar.gz http://grafanarel.s3.amazonaws.com/grafana-1.8.1.tar.gz && \
  curl -s -o /src/influxdb_latest_amd64.deb http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb

WORKDIR /src
RUN \
  tar xzvf grafana-1.8.1.tar.gz --strip-components=1 && \
  dpkg -i influxdb_latest_amd64.deb && \
  rm \
    grafana-1.7.0.tar.gz \
    influxdb_latest_amd64.deb \

EXPOSE 80 8083 8086




# Download our packages

#RUN \
#  curl -s -o /tmp/grafana-1.8.1.tar.gz http://grafanarel.s3.amazonaws.com/grafana-1.8.1.tar.gz && \
#  curl -s -o /tmp/influxdb_latest_amd64.deb http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb


#  tar xzvf /tmp/grafana-1.7.0.tar.gz --strip-components=1 && \


#  apt-get install wget && \
#  wget http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb -o /tmp/influxdb_latest_amd64.deb && \
#  dpkg -i /tmp/influxdb_latest_amd64.deb && \
#  rm /tmp/influxdb_latest_amd64.deb && \
#  echo "influxdb soft nofile unlimited" >> /etc/security/limits.conf && \
#  echo "influxdb hard nofile unlimited" >> /etc/security/limits.conf



# CMD ["supervisord", "-n"]