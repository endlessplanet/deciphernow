#!/bin/sh

if [ ! -f ${HOME}/docker/containers/cloud9-${1} ]
then
    docker-container-start-browser &&
        docker \
            container \
            create \
            --cidfile ${HOME}/docker/containers/cloud9-${1} \
            --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
            $(cat ${HOME}/docker/images/cloud9) &&
        docker network connect --alias "${1}" $(cat ${HOME}/docker/networks/regular) $(cat ${HOME}/docker/containers/cloud9-${@}) &&
        docker container start $(cat ${HOME}/docker/containers/cloud9-${1})
fi