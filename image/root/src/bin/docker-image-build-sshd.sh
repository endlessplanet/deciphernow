#!/bin/sh

if [ ! -f ${HOME}/docker/images/sshd ]
then
    cd /opt/docker/src/images/sshd &&
        docker image build --label expiry=$(date --date "now + 1 month" +%s) --iidfile ${HOME}/docker/images/sshd .
fi