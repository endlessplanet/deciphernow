#!/bin/sh

(
    THIS=$(cat /var/opt/docker/sshd.counter) &&
        NEXT=$((${THIS}+1)) &&
        echo "${1}" >> /root/.ssh/authorized_keys &&
        echo ${NEXT} > /var/opt/docker/sshd.counter &&
        echo ${THIS}
) 200> /var/opt/docker/sshd.lock