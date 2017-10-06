#!/bin/sh

NET=$(mktemp) &&
    DIND=$(mktemp) &&
    WORK=$(mktemp) &&
    cleanup(){
        docker container stop $(cat ${DIND}) $(cat ${WORK}) &&
            docker container rm --volumes $(cat ${DIND}) $(cat ${WORK}) &&
            docker network rm $(cat ${NET}) &&
            rm -f ${DIND} ${WORK} ${NET}
    } &&
    trap cleanup EXIT &&
    rm -f ${DIND} ${WORK} &&
    docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker image pull docker:17.09.0-dind &&
    docker image pull endlessplanet/deciphernow:$(git rev-parse --verify HEAD) &&
    docker \
        container \
        create \
        --cidfile ${DIND} \
        --privileged \
        --volume /tmp/.X11-unix:/var/opt/.X11-unix:ro \
        docker:17.09.0-dind \
            --host tcp://0.0.0.0:2376 &&
    docker \
        container \
        create \
        --cidfile ${WORK} \
        --interactive \
        --tty \
        --env DOCKER_HOST=tcp://docker:2376 \
        endlessplanet/deciphernow:$(git rev-parse --verify HEAD) &&
    docker network create $(uuidgen) > ${NET} &&
    docker network connect --alias docker $(cat ${NET}) $(cat ${DIND}) &&
    docker network connect $(cat ${NET}) $(cat ${WORK}) &&
    docker container start $(cat ${DIND}) &&
    docker container start --interactive $(cat ${WORK})