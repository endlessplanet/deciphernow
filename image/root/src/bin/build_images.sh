#!/bin/sh

ls -1 /opt/docker/src/images | while read DIR
do
    cd /opt/docker/src/images/${DIR} &&
        docker image build --label title=${DIR} --label expiry=$(date --date "now + 1 month" +%s) .
done