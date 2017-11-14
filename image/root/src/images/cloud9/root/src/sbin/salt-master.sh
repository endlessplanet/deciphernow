#!/bin/sh

yum update --assumeyes &&
    yum install --assumeyes procps-ng &&
    yum install --assumeyes curl &&
    yum install --assumeyes salt-master &&
    ln --symbolic --force /opt/docker/workspace/saltstack/repo/srv/salt /srv/salt &&
    ln --symbolic --force /opt/docker/workspace/saltstack/repo/srv/pillar /srv/pillar &&
    cat /opt/docker/etc/master.txt >> /etc/salt/master &&
    yum update --assumeyes &&
    yum clean all &&
    /usr/bin/salt-master