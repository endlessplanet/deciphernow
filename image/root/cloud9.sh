#!/bin/sh

PUBLIC_KEY_FILE=$(mktemp) &&
    cleanup() {
        rm --force ${PUBLIC_KEY_FILE}
    }
    trap cleanup EXIT &&
    rm ${PUBLIC_KEY_FILE} &&
    ADVENTURE_NAME="${1}" &&
    SHELL_CIDFILE=$(mktemp ${HOME}/docker/containers/shell-XXXXXXXX) &&
    CLOUD9_CIDFILE=$(mktemp ${HOME}/docker/containers/cloud9-XXXXXXXX) &&
    rm --force ${SHELL_CIDFILE} ${CLOUD9_CIDFILE} &&
    sudo docker container create --cidfile ${SHELL_CIDFILE} --volume /var/run/docker.sock:/var/run/docker.sock:ro fedora:26 sleep infinite &&
    sudo docker container create --cidfile ${CLOUD9_CIDFILE} --volume /var/run/docker.sock:/var/run/docker.sock:ro sapk/cloud9 --auth user:password &&
    sudo docker network connect ${NETWORK} $(cat ${SHELL_CIDFILE}) &&
    sudo docker network connect --alias ${ADVENTURE_NAME} ${NETWORK} $(cat ${CLOUD9_CIDFILE}) &&
#    sudo docker container start ${SHELL_CIDFILE} &&
    sudo docker container start $(cat ${CLOUD9_CIDFILE}) &&
    sudo docker container exec --interactive --tty $(cat ${CLOUD9_CIDFILE}) mkdir /root/.ssh &&
    sudo docker container exec --interactive --tty $(cat ${CLOUD9_CIDFILE}) ssh-keygen -f /root/.ssh/id_rsa -P "" &&
    sudo docker container exec --interactive --tty $(cat ${CLOUD9_CIDFILE}) cat /root/.ssh/id_rsa.pub | sudo docker container exec --interactive $(cat ${HOME}/docker/containers/sshd) tee --append /root/.ssh/authorized_keys &&
    true