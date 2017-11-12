#!/bin/sh

docker network ls --quiet --filter label=expiry | while read NETWORK
do
    [ $(date +%s) -gt $(docker network inspect --format "{{index .Config.Labels \"expiry\"}}" ${NETWORK}) ] &&
        docker network rm ${NETWORK}
done