#!/bin/bash

setupcerts() {
    # Begin cert creation process
    getssl -c $SERVER -w $WORKDIR
    service haproxy start
    getssl -a -w $WORKDIR
    echo "Done with GETSSL init"
}

buildconf() {
    echo "Rebuilding conf"
    FRONT=$(docker ps --format '\n   acl {{.Names}}-api  hdr_beg(host) -i {{.Label "subdomain"}}.\n   use_backend {{.Names}}-backend if {{.Names}}-api\n' --filter "label=api")
    DEFAULT=$(docker ps --format '\n   default_backend {{.Names}}-backend\n' --filter "label=api" --filter "label=default")
    BACK=$(docker ps --format 'backend {{.Names}}-backend\n   server {{.Label "subdomain" }}-server {{.Names}}:{{.Label "port" }}\n\n' --filter "label=api")

    FRONT="$FRONT" DEFAULT="$DEFAULT" BACK="$BACK" /docproxy/docproxy.tmpl > /etc/haproxy/haproxy.cfg
    service haproxy reload
}

watchdocker() {
    while read line
    do
        echo $line
        buildconf
    done < /dev/stdin
}

setupcerts
buildconf
docker events --filter event=start --filter event=stop --filter label=api | watchdocker
