#!/bin/sh

ssh-keygen -f /root/.ssh/id_rsa -P "" > /dev/null 2>&1 &&
    ssh-keyscan sshd > /root/.ssh/known_hosts &&
    chmod 0755 /root/.ssh/known_hosts
    cat /root/.ssh/id_rsa.pub