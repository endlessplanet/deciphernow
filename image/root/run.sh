#!/bin/sh

apk update &&
    apk upgrade &&
    adduser -D user &&
    apk add --no-cache sudo &&
    cp /opt/docker/user.sudo /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    mkdir /home/user/docker &&
    mkdir /home/user/docker/containers &&
    mkdir /home/user/docker/volumes &&
    mkdir /home/user/docker/networks &&
    chown -R user:user /home/user/docker &&
    apk add --no-cache util-linux &&
    apk add --no-cache bash &&
    rm -rf /var/cache/apk/*