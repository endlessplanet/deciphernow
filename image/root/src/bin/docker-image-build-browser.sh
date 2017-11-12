#!/bin/sh

cd /opt/docker/src/images/browser &&
    docker image build --quiet --label expiry=$(date "now + 1 month" +%s) > ${HOME}/docker/images/browser