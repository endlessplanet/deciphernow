#!/bin/sh

docker image ls --quiet --filter label=expiry | while read IMAGE
do
    [ $(date +%s) -gt $(docker image inspect --format "{{index .Config.Labels expiry}}" ${IMAGE}) ] &&
        docker image rm ${IMAGE}
done