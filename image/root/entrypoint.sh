#!/bin/sh

cleanup() {
    ls -1 ${HOME}/docker/containers | while read FILE
    do
        sudo docker container stop $(cat ${HOME}/docker/containers/${FILE}) &&
            sudo docker container rm --volumes $(cat ${HOME}/docker/containers/${FILE}) &&
            rm --force ${HOME}/docker/containers/${FILE}
    done &&
    ls -1 ${HOME}/docker/volumes | while read FILE
    do
        sudo docker volume rm $(cat ${HOME}/docker/volumes/${FILE}) &&
            rm --force ${HOME}/docker/volumes/${FILE}
    done
} &&
    trap cleanup EXIT &&
    sudo docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    sudo docker image pull endlessplanet/sshd:ca675205de9d945aac60f35885ae75a71f9de123 &&
    sudo docker image pull endlessplanet/shell:37517fbdf6c6782288fa256705a6898a8bf78d6d &&
    sudo docker image pull endlessplanet/cloud9:44bdeb0620f3b29849d3e2b0b8ded5d696ac93fe &&
    mkdir ${HOME}/docker &&
    mkdir ${HOME}/docker/containers &&
    mkdir ${HOME}/docker/volumes &&
    mkdir ${HOME}/docker/ports &&
    sudo docker container create --cidfile ${HOME}/docker/containers/sshd endlessplanet/sshd:ca675205de9d945aac60f35885ae75a71f9de123 &&
    sudo docker network connect --alias sshd ${NETWORK} $(cat ${HOME}/docker/containers/sshd) &&
    sudo docker container start $(cat ${HOME}/docker/containers/sshd) &&
    bash