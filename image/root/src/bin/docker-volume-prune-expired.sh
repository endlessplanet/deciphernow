#!/bin/sh

docker volume ls --quiet --filter label=expiry | while read VOLUME
do
    [ $(date +%s) -gt $(docker volume inspect --format "{{index .Labels \"expiry\"}}" ${VOLUME}) ] &&
        docker volume rm ${VOLUME}
done