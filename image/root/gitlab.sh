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
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --volume $(cat ${HOME}/docker/volumes/workspace-${ADVENTURE}):/workspace/${ADVENTURE_NAME} \
        endlessplanet/cloud9:b14850c8fe1701dc5da91b91e3e5fceb84c4dde2 --listen localhost &&
    sudo docker network connect ${NETWORK} $(cat ${SHELL_CIDFILE}) &&
    sudo docker network connect --alias ${ADVENTURE_NAME} ${NETWORK} $(cat ${CLOUD9_CIDFILE}) &&
#    sudo docker container start ${SHELL_CIDFILE} &&
    sudo docker container start $(cat ${CLOUD9_CIDFILE}) &&
    sudo docker container exec --interactive --tty ${CLOUD9_CIDFILE} cat /root/.ssh/id_rsa | sudo docker container exec --interactive $(cat ${HOME}/docker/containers/) sh /opt/docker/reserve-ports.sh > ${HOME}/docker/ports/${ADVENTURE_NAME} &&
    sudo docker container exec --detach $(cat ${CLOUD9_CIDFILE}) ssh -fN -R 127.0.0.1:${SSHD_PORT}:127.0.0.1:8181 sshd &&
    sudo docker container exec --detach $(cat ${CLOUD9_CIDFILE}) ssh -fN -L 0.0.0.0:80:0.0.0.0:${SSHD_PORT} sshd &&
    # sudo docker container exec $(cat ${CLOUD9_CIDFILE}) ssh sshd &&
    true