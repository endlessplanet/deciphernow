#!/bin/sh

if [ ! -f ${HOME}/docker/images/browser ]
then
    cd /opt/docker/src/images/browser &&
        docker image build --label expiry=$(date --date "now + 1 month" +%s) --iidfile ${HOME}/docker/images/browser .
fi