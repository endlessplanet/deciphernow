#!/bin/sh

apk update &&
    apk upgrade &&
    apk add --no-cache bash &&
    adduser -D user &&
    mkdir /home/user/bin &&
    ls -1 /opt/docker/src/bin | while read FILE
    do
        cp /opt/docker/src/bin/${FILE} /home/user/bin/${FILE%.*} &&
            chmod 0500 /home/user/bin/${FILE%.*}
    done &&
    chown -R user:user /home/user/bin &&
    ln -sf /home/user/bin/bashrc /home/user/.bashrc &&
    rm -rf /var/cache/apk/*