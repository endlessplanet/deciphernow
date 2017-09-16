#!/bin/sh

ADVENTURE_NAME="${1}" &&
    SHELL_CIDFILE=$(mktemp ${HOME}/docker/containers/shell-${ADVENTURE_NAME}-XXXXXXXX) &&
    CLOUD9_CIDFILE=$(mktemp ${HOME}/docker/containers/cloud9-${ADVENTURE_NAME}-XXXXXXXX) &&
    rm --force ${SHELL_CIDFILE} ${CLOUD9_CIDFILE} &&
    sudo docker volume create > ${HOME}/docker/volumes/workspace-${ADVENTURE_NAME} &&
    sudo \
        docker \
        container \
        create \
        --cidfile ${SHELL_CIDFILE} \
        --env DISPLAY \
        --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
        --volume $(cat ${HOME}/docker/volumes/workspace-${ADVENTURE_NAME}):/workspace/${ADVENTURE_NAME} \
        endlessplanet/shell:a8b5760957e9f2f4ef25002b8b0861f63ac800bc \
        sleep infinite &&
    sudo \
        docker \
        container \
        create \
        --cidfile ${CLOUD9_CIDFILE} \
        --env SSHD_CONTAINER=$(cat ${HOME}/docker/containers/sshd) \
        --env SHELL_CONTAINER=$(cat ${SHELL_CIDFILE}) \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --volume $(cat ${HOME}/docker/volumes/workspace-${ADVENTURE_NAME}):/workspace/${ADVENTURE_NAME} \
        endlessplanet/cloud9:82f34c862fec0528dbf3431b6ceba9debfcf9398 &&
    sudo docker network connect ${NETWORK} $(cat ${SHELL_CIDFILE}) &&
    sudo docker network connect --alias ${ADVENTURE_NAME} ${NETWORK} $(cat ${CLOUD9_CIDFILE}) &&
    sudo docker container start $(cat ${SHELL_CIDFILE}) &&
    sudo docker container start $(cat ${CLOUD9_CIDFILE})