#!/bin/sh

ADVENTURE_NAME="${1}" &&
    SHELL_CIDFILE=$(mktemp ${HOME}/docker/containers/shell-${ADVENTURE_NAME}-XXXXXXXX) &&
    CLOUD9_CIDFILE=$(mktemp ${HOME}/docker/containers/cloud9-${ADVENTURE_NAME}-XXXXXXXX) &&
    rm --force ${SHELL_CIDFILE} ${CLOUD9_CIDFILE} &&
    sudo docker volume create > ${HOME}/docker/volumes/workspace-${ADVENTURE_NAME} &&
    sudo docker container create --cidfile ${SHELL_CIDFILE} --volume /var/run/docker.sock:/var/run/docker.sock:ro fedora:26 sleep infinite &&
    sudo \
        docker \
        container \
        create \
        --cidfile ${CLOUD9_CIDFILE} \
        --env SSHD_CONTAINER=$(cat ${HOME}/docker/containers/sshd) \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --volume $(cat ${HOME}/docker/volumes/workspace-${ADVENTURE_NAME}):/workspace/${ADVENTURE_NAME} \
        endlessplanet/cloud9:b14850c8fe1701dc5da91b91e3e5fceb84c4dde2 --listen localhost &&
    sudo docker network connect --alias ${ADVENTURE_NAME} ${NETWORK} $(cat ${CLOUD9_CIDFILE}) &&
    sudo docker container start $(cat ${CLOUD9_CIDFILE}) &&
    sudo docker container exec --detach $(cat ${CLOUD9_CIDFILE}) ssh -fN -R 127.0.0.1:${SSHD_PORT}:127.0.0.1:8181 sshd &&
    sudo docker container exec --detach $(cat ${CLOUD9_CIDFILE}) ssh -fN -L 0.0.0.0:80:0.0.0.0:${SSHD_PORT} sshd &&
    # sudo docker container exec $(cat ${CLOUD9_CIDFILE}) ssh sshd &&
    true