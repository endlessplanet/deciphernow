#!/bin/sh

cleanup() {
    ls -1 ${HOME}/docker/containers | while read FILE
    do
        sudo docker container stop $(cat ${HOME}/docker/containers/${FILE}) &&
            sudo docker container rm --volumes $(cat ${HOME}/docker/containers/${FILE}) &&
            rm --force ${HOME}/docker/containers/${FILE}
    done
} &&
    trap cleanup EXIT &&
    sudo docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    sudo docker image pull rastasheep/ubuntu-sshd:16.04 &&
    sudo docker image pull fedora:26 &&
    sudo docker image pull sapk/cloud9 &&
    mkdir ${HOME}/docker &&
    mkdir ${HOME}/docker/containers &&
    sudo docker container create --cidfile ${HOME}/docker/containers/sshd rastasheep/ubuntu-sshd:16.04 &&
    sudo docker network connect --alias sshd ${NETWORK} $(cat ${HOME}/docker/containers/sshd) &&
    sudo docker container start $(cat ${HOME}/docker/containers/sshd)
    bash