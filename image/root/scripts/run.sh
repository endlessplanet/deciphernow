#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache sudo bash coreutils &&
    cp /opt/docker/etc/user.sudo.txt /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    adduser -D user &&
    mkdir /opt/docker/bin &&
    ls -1 /opt/docker/src/bin | while read FILE
    do
        cp /opt/docker/src/bin/${FILE} /opt/docker/bin/${FILE%.*} &&
            chmod 0555 /opt/docker/bin/${FILE%.*}
    done &&
    ln -sf /opt/docker/bin/bashrc /home/user/.bashrc &&
    mkdir /home/user/docker &&
    mkdir /home/user/docker/containers &&
    mkdir /home/user/docker/networks &&
    rm -rf /var/cache/apk/*