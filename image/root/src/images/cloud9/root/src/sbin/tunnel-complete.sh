#!/bin/sh

ssh-keyscan sshd > /root/.ssh/known_hosts &&
    chmod 0755 /root/.ssh/known_hosts &&
    (nohup ssh -i /root/.ssh/id_rsa -N -R 127.0.0.1:${1}:127.0.0.1:8181 sshd > /tmp/sshd1.log 2>&1 &) &&
    (nohup ssh -i /root/.ssh/id_rsa N -L 0.0.0.0:80:0.0.0.0:${1} sshd > /tmp/sshd2.log 2>&1 &) &&
    sleep 120s