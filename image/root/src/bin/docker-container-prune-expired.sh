#!/bin/sh

docker container ls --quiet --all --filter label=expiry | while read CONTAINER
do
    [ $(date +%s) -gt $(docker container inspect --format "{{index .Config.Labels \"expiry\"}}" ${CONTAINER}) ] &&
        docker container stop ${CONTAINER} &&
        docker container rm --volumes ${CONTAINER}
done