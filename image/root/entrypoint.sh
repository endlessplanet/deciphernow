#!/bin/sh

export PATH=${HOME}/bin:${PATH}
    trap wipe-clean EXIT &&
    docker image pull docker:17.09.0-dind &&
    docker image pull gitlab/gitlab-runner:v1.11.2 &&
    docker \
        container \
        create \
        --cidfile ${HOME}/docker/containers/gitlab-runner \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        gitlab/gitlab-runner:v1.11.2 &&
    docker container start $(cat ${HOME}/docker/containers/gitlab-runner) &&
    bash
#     trap cleanup EXIT &&
#     sudo docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
#     sudo docker image pull ${SSHD_IMAGE} &&
#     sudo docker image pull ${CLOUD9_IMAGE} &&
#     sudo docker container create --cidfile ${HOME}/docker/containers/sshd endlessplanet/sshd:ca675205de9d945aac60f35885ae75a71f9de123 &&
#     sudo docker network connect --alias sshd entrypoint_default $(cat ${HOME}/docker/containers/sshd) &&
#     sudo docker container start $(cat ${HOME}/docker/containers/sshd) &&
    