#!/bin/sh

cd /opt/docker/src/images/cloud9 &&
    docker image build --quiet --label expiry=$(date --date "now + 1 month" +%s) > ${HOME}/docker/images/cloud9