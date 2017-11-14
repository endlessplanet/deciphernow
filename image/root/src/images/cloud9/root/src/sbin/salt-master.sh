#!/bin/sh

yum update --assumeyes &&
    yum install --assumeyes procps-ng &&
    yum install --assumeyes curl &&
    ln --symbolic --force /workspace/saltstack/repo/srv/salt /srv/salt &&
    ln --symbolic --force /workspace/saltstack/repo/srv/pillar /srv/pillar &&
    mkdir /workspace &&
    chown user:user /workspace &&
    cat /opt/docker/etc/master.txt >> /etc/salt/master &&
    yum update --assumeyes &&
    yum clean all &&
    /usr/bin/salt-master