#!/bin/sh

dnf update --assumeyes &&
    dnf install --assumeyes git make python tar which bzip2 ncurses gmp-devel mpfr-devel libmpc-devel glibc-devel flex bison glibc-static zlib-devel gcc gcc-c++ nodejs &&
    mkdir /opt/docker/c9sdk &&
    git -C /opt/docker/c9sdk init &&
    git -C /opt/docker/c9sdk remote add origin git://github.com/c9/core.git &&
    git -C /opt/docker/c9sdk pull origin master &&
    /opt/docker/c9sdk/scripts/install-sdk.sh &&
    cp /opt/docker/etc/docker.repo /etc/yum.repos.d/ &&
    dnf update --assumeyes &&
    dnf install --assumeyes docker-engine &&
    dnf install --assumeyes util-linux-user &&
    adduser user &&
    dnf install --assumeyes sudo &&
    cp /opt/docker/user.sudo /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    mkdir /opt/docker/workspace &&
    chown user:user /opt/docker/workspace &&
    mkdir /opt/docker/bin &&
    ls -1 /opt/docker/src/bin | while read FILE
    do
        cp /opt/docker/src/bin/${FILE} /opt/docker/bin/${FILE%.*} &&
            chmod 0555 /opt/docker/bin/${FILE%.*}
    done &&
    dnf update --assumeyes &&
    dnf clean all &&
    true