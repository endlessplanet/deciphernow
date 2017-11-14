#!/bin/sh

if [ ! -f ${HOME}/docker/images/vpn ]
then
    cd /opt/docker/src/images/vpn &&
        docker image build --label expiry=$(date --date "now + 1 month" +%s) --iidfile ${HOME}/docker/images/vpn .
fi