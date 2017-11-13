#!/bin/sh

ssh -i /root/.ssh/id_rsa -N -L 0.0.0.0:80:0.0.0.0:${1} sshd > /tmp/sshd2.log 2> /tmp/sshd2.err
echo ${?} > /tmp/sshd2.code