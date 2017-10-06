#!/bin/sh

NETW=$(mktemp) &&
    DIND=$(mktemp) &&
    WORK=$(mktemp) &&
    cleanup(){
        docker container stop $(cat ${DIND}) $(cat ${WORK}) &&
            docker container rm --volumes $(cat ${DIND}) $(cat ${WORK}) &&
            docker network rm $(cat ${NETW}) &&
            rm -f ${DIND} ${WORK} ${NETW}
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
    docker network create $(uuidgen) > ${NETW} &&
    docker networsk connect --alias docker $(cat ${NETW}) $(cat ${DIND}) &&
    docker network connect $(cat ${WORK}) $(cat ${DIND}) &&
    docker container start $(cat ${DIND}) &&
    docker container start --interactive $(cat ${WORK})