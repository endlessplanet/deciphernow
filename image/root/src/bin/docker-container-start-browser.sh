#!/bin/sh

if [ ! -f ${HOME}/docker/containers/browser ]
then
    docker-image-build-browser &&
        docker-volume-create-home &&
        docker \
            container \
            create \
            --cidfile ${HOME}/docker/containers/browser \
            --mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
            --mount type=volume,source=$(cat ${HOME}/docker/volumes/home),destination=/home \
            --env DISPLAY \
            --label expiry=$(date --date "${EXPIRY}" +%s) \
            $(cat ${HOME}/docker/images/browser) &&
            docker-network-start-regular &&
            docker network connect $(cat ${HOME}/docker/networks/regular) $(cat ${HOME}/docker/containers/browser)
            docker container start $(cat ${HOME}/docker/containers/browser)
fi