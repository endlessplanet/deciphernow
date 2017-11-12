#!/bin/sh

apt-get update --assume-yes &&
    sed -i "s,#GatewayPorts no,GatewayPorts yes," /etc/ssh/sshd_config &&
    mkdir /var/opt/docker &&
    echo $((${RANDOM}%10000+20000)) > /var/opt/docker/sshd.counter &&
    touch /root/.ssh/authorized_keys &&
    chmod 0600 /root/.ssh/authorized_keys &&
    apt-get update --assume-yes &&
    apt-get clean all