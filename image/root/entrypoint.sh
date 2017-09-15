#!/bin/sh

cleanup() {
    ls -1 ${HOME}/docker/containers | while read FILE
    do
        docker container stop $(cat ${HOME}/docker/containers/${FILE}) &&
            docker container rm --volumes $(cat ${HOME}/docker/containers/${FILE}) &&
            rm --force ${HOME}/docker/containers/${FILE}
    done
} &&
    trap cleanup EXIT &&
    docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker image pull rastasheep/ubuntu-sshd:16.04 &&
    mkdir ${HOME}/docker &&
    mkdir ${HOME}/docker/containers &&
    docker container create --cidfile ${HOME}/docker/containers/sshd rastasheep/ubuntu-sshd:16.04 &&
    docker container start $(cat ${HOME}/docker/containers/sshd)
    bash