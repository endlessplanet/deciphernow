#!/bin/sh

if [ ! -f ${HOME}/docker/images/cloud9 ]
then
    cd /opt/docker/src/images/cloud9 &&
        docker image build --label expiry=$(date --date "now + 1 month" +%s) --iidfile ${HOME}/docker/images/cloud9 .
fi