FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install cron python sed openssl curl dnsutils haproxy docker.io

# Add crontab file in the cron directory
ADD crontab /etc/cron.d/getssl-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/getssl-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log
RUN mkdir -p /challenge/.well-known/acme-challenge

ADD getssl.tmpl /getssl/getssl.tmpl
RUN curl --silent https://raw.githubusercontent.com/srvrco/getssl/master/getssl > /usr/bin/getssl ; chmod 700 /usr/bin/getssl

ADD haproxy.cfg /etc/haproxy/haproxy.cfg
ADD docproxy.sh /docproxy/docproxy.sh
ADD docproxy.tmpl /docproxy/docproxy.tmpl

ADD startup.sh /startup.sh

EXPOSE 80
EXPOSE 443

CMD /startup.sh
