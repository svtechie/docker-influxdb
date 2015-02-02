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
    python-dev


WORKDIR /opt
RUN \
  grafana_url=$(curl http://grafanarel.s3.amazonaws.com/latest.json | python -c 'import sys, json; print json.load(sys.stdin)["url"]') && \
  curl -s -o grafana.tar.gz $grafana_url && \
  curl -s -o influxdb_latest_amd64.deb http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb && \
  mkdir grafana && \
  tar -xzf grafana.tar.gz --directory grafana --strip-components=1 && \
  dpkg -i influxdb_latest_amd64.deb && \
  echo "influxdb soft nofile unlimited" >> /etc/security/limits.conf && \
  echo "influxdb hard nofile unlimited" >> /etc/security/limits.conf

ADD config.js /opt/grafana/config.js
ADD nginx.conf /etc/nginx/nginx.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD types.db /opt/influxdb/current/types.db
ADD config.toml /opt/influxdb/current/config.toml

VOLUME ["/opt/influxdb/shared/data"]

EXPOSE 80 8083 8086 8096

CMD ["supervisord", "-n"]
