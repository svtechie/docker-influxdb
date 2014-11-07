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
    python-dev


WORKDIR /src
RUN \
  curl -s -o /src/grafana-1.8.1.tar.gz http://grafanarel.s3.amazonaws.com/grafana-1.8.1.tar.gz && \
  curl -s -o /src/influxdb_latest_amd64.deb http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb && \
  tar xzvf grafana-1.8.1.tar.gz --strip-components=1 && \
  dpkg -i influxdb_latest_amd64.deb && \
  rm \
    grafana-1.7.0.tar.gz \
    influxdb_latest_amd64.deb \

# Configuration

ADD supervisord.conf /etc/supervisor/conf.d/
#ADD config.toml /etc/influxdb/


#ADD config.toml /etc/influxdb/config.toml
#ADD influxdb/config.toml /etc/influxdb/config.toml 
#ADD influxdb/run.sh /usr/local/bin/run_influxdb
#RUN chmod 0755 /usr/local/bin/run_influxdb

#add     ./grafana/config.js /src/grafana/config.js
#add     ./nginx/nginx.conf /etc/nginx/nginx.conf
#add     ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#cmd     ["/usr/bin/supervisord"]

EXPOSE 80 8083 8086

CMD ["supervisord", "-n"]


#  echo "influxdb soft nofile unlimited" >> /etc/security/limits.conf && \
#  echo "influxdb hard nofile unlimited" >> /etc/security/limits.conf



