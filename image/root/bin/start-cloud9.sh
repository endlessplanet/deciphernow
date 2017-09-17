#!/bin/sh

ADVENTURE_NAME="${1}" &&
    SHELL_CIDFILE="${2}" &&
    CLOUD9_CIDFILE=$(mktemp ${HOME}/docker/containers/cloud9-${ADVENTURE_NAME}-XXXXXXXX) &&
    rm --force ${SHELL_CIDFILE} ${CLOUD9_CIDFILE} &&
    sudo docker volume create > ${HOME}/docker/volumes/workspace-${ADVENTURE_NAME} &&
    sudo \
        docker \
        container \
        create \
        --cidfile ${SHELL_CIDFILE} \
        --env DISPLAY \
        --env MASTER_BRANCH=develop \
        --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
        --volume $(cat ${HOME}/docker/volumes/workspace-${ADVENTURE_NAME}):/workspace/${ADVENTURE_NAME} \
        endlessplanet/shell:b110d49f662e19b2735417c3e280a4e3195c8d0a \
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
        endlessplanet/cloud9:44bdeb0620f3b29849d3e2b0b8ded5d696ac93fe &&
    sudo docker network connect ${NETWORK} $(cat ${SHELL_CIDFILE}) &&
    sudo docker network connect --alias ${ADVENTURE_NAME} ${NETWORK} $(cat ${CLOUD9_CIDFILE}) &&
    sudo docker container start $(cat ${SHELL_CIDFILE}) &&
    sudo docker container start $(cat ${CLOUD9_CIDFILE}) &&
    cat ${SHELL_CIDFILE}