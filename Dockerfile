FROM ubuntu
MAINTAINER Matt Baldwin (baldwin@stackpointcloud.com)

RUN \
  apt-get update && apt-get -y --no-install-recommends install \
    ca-certificates \
    software-properties-common \
    python-django-tagging \
    python-simplejson \
    python-memcache \
    python-ldap \
    python-cairo \
    python-pysqlite2 \
    python-pip \
    gunicorn \
    supervisor \
    nginx-light \
    nodejs \
    git \
    curl \
    wget \
    default-jre \
    build-essential \
    python-dev


WORKDIR /opt
RUN \
  curl -s -o grafana.tar.gz "https://grafanarel.s3.amazonaws.com/builds/grafana-latest.linux-x64.tar.gz" && \
  wget https://dl.influxdata.com/influxdb/releases/influxdb_1.2.2_amd64.deb && \
  wget http://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb && \
  dpkg -i python-support_1.0.15_all.deb && \
  mkdir /opt/grafana && \
  tar -xzf grafana.tar.gz --directory /opt/grafana --strip-components=1 && \
  dpkg -i influxdb_1.2.2_amd64.deb && \
  echo "influxdb soft nofile unlimited" >> /etc/security/limits.conf && \
  echo "influxdb hard nofile unlimited" >> /etc/security/limits.conf

ADD config.js /opt/grafana/config.js
ADD nginx.conf /etc/nginx/nginx.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD config.toml /opt/influxdb/current/config.toml

VOLUME ["/opt/influxdb/shared/data"]

EXPOSE 80 8083 8086 2003 3000

CMD ["supervisord", "-n"]
