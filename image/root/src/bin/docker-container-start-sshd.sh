#!/bin/sh

if [ ! -f ${HOME}/docker/containers/sshd ]
then
    docker-volume-create-chimera_dot_ssh.sh &&
    docker-image-build-sshd &&
        docker \
            container \
            create \
            --cidfile ${HOME}/docker/containers/sshd \
            --label expiry=$(date --date "${EXPIRY}" +%s) \
            --mount type=bind,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home,type=readonly \
            $(cat ${HOME}/docker/images/sshd) &&
            docker-network-start-regular &&
            docker network connect --alias sshd $(cat ${HOME}/docker/networks/regular) $(cat ${HOME}/docker/containers/sshd)
            docker container start $(cat ${HOME}/docker/containers/sshd)
fi