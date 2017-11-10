#!/bin/sh

if [ ! -f ${HOME}/docker/containers/browser ]
then
    docker \
        container \
        create \
        --cidfile ${HOME}/docker/containers/browser \
        --mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
        --env DISPLAY \
        $(docker image ls --quiet --filter label=title=browser | head -n 1) &&
        docker-network-start-regular &&
        docker network connect $(cat ${HOME}/docker/networks/regular) $(cat ${HOME}/docker/containers/browser)
        docker container start $(cat ${HOME}/docker/containers/browser)
fi