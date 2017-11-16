#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache sudo bash coreutils util-linux openssh curl &&
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
    mkdir /home/user/docker/images &&
    mkdir /home/user/docker/containers &&
    mkdir /home/user/docker/networks &&
    mkdir /home/user/docker/volumes &&
    chown -R user:user /home/user/docker &&
    rm -rf /var/cache/apk/*