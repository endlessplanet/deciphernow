#!/bin/sh

apk update &&
    apk upgrade &&
    apk add bash &&
    adduser -D user &&
    mkdir /home/user/docker &&
    mkdir /home/user/docker/containers &&
    mkdir /home/user/docker/volumes &&
    chown user:user /home/user/docker &&
    rm -rf /var/cache/apk/*