#!/bin/sh

if [ ! -f ${HOME}/docker/containers/cloud9-${1} ]
then
    docker-image-build-cloud9 &&
    docker-container-start-sshd &&
    docker-container-start-browser &&
        docker \
            container \
            create \
            --label expiry=$(date --date "${EXPIRY}" +%s) \
            --cidfile ${HOME}/docker/containers/cloud9-${1} \
            --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
            $(cat ${HOME}/docker/images/cloud9) &&
        docker network connect --alias "${1}" $(cat ${HOME}/docker/networks/regular) $(cat ${HOME}/docker/containers/cloud9-${@}) &&
        docker container start $(cat ${HOME}/docker/containers/cloud9-${1}) &&
        docker \
            container \
            exec \
            --interactive \
            --tty \
            --user root \
            $(cat ${HOME}/docker/containers/cloud9-${1})
                $(docker container exec --interactive --tty $(cat ${HOME}/docker/containers/sshd) sh /opt/docker/src/bin/reserve.sh)
fi