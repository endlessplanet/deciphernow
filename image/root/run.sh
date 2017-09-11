#!/bin/sh

apk update &&
    apk upgrade &&
    adduser -D user &&
    apk add --no-cache sudo &&
    cp /opt/docker/user.sudo /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    mkdir /root/docker &&
    mkdir /root/docker/containers &&
    mkdir /root/docker/volumes &&
    mkdir /root/docker/networks &&
#    chown -R user:user /root/docker &&
    apk add --no-cache util-linux &&
    apk add --no-cache bash &&
    rm -rf /var/cache/apk/*