#!/bin/sh
apk update &&
    apk upgrade &&
    apk add --no-cache openssl openvpn openssh &&
    adduser -D user &&
    mkdir /root/.ssh &&
    chmod 0700 /root/.ssh &&
    touch /root/.ssh/id_rsa &&
    chmod 0600 /root/.ssh/id_rsa &&
    rm -rf /var/cache/apk/*