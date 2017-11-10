#!/bin/sh

if [ ! -f ${HOME}/docker/containers/cloud9-${@} ]
then
    docker-container-start-browser &&
        docker \
            container \
            create \
            --cidfile ${HOME}/docker/containers/cloud9-${@} \
            --mount --type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
            $(docker image ls --quiet --filter label=title=cloud9 | head -n 1) &&
        docker network connect --alias "${@}" $(cat ${HOME}/networks/regular) $(cat ${HOME}/docker/containers/cloud9-${@}) &&
        docker container start $(cat ${HOME}/docker/containers/cloud9-${@})
fi