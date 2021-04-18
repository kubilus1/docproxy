#!/bin/sh

#WORKDIR='/root/.getssl'
WORKDIR=/cert/cfg

# Create getssl config
mkdir -p $WORKDIR/$SERVER
sed -e 's|##SANS##|'"$SANS"'|g' /getssl/getssl.tmpl > $WORKDIR/$SERVER/getssl.cfg

# Setup ACME challenge server
cd /challenge && python -m SimpleHTTPServer &
sleep 2

# Use cron to keep things up-to-date
cron

# Start docproxy
/docproxy/docproxy.sh
