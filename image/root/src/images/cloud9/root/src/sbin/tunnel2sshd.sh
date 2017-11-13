#!/bin/sh

ssh -i /root/.ssh/id_rsa -N -R 0.0.0.0:${1}:127.0.0.1:8181 sshd > /tmp/sshd1.log 2>&1