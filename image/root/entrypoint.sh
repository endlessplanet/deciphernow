#!/bin/sh

export PATH=${HOME}/bin:${PATH}
    trap wipe-clean EXIT &&
    bash
#     trap cleanup EXIT &&
#     sudo docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
#     sudo docker image pull ${SSHD_IMAGE} &&
#     sudo docker image pull ${CLOUD9_IMAGE} &&
#     sudo docker container create --cidfile ${HOME}/docker/containers/sshd endlessplanet/sshd:ca675205de9d945aac60f35885ae75a71f9de123 &&
#     sudo docker network connect --alias sshd entrypoint_default $(cat ${HOME}/docker/containers/sshd) &&
#     sudo docker container start $(cat ${HOME}/docker/containers/sshd) &&
    