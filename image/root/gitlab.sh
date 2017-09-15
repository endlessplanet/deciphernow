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
        endlessplanet/cloud9:dbd265b9afb139e84a51b26bcf0004aa2dfa6051 &&
    sudo docker network connect --alias ${ADVENTURE_NAME} ${NETWORK} $(cat ${CLOUD9_CIDFILE}) &&
    sudo docker container start $(cat ${CLOUD9_CIDFILE}) &&
    # sudo docker container exec $(cat ${CLOUD9_CIDFILE}) ssh sshd &&
    true