#!/bin/sh

CIDFILE=$(mktemp) &&
    cleanup(){
        docker container stop $(cat ${CIDFILE}) &&
            docker container rm --volumes $(cat ${CIDFILE}) &&
            rm -f ${CIDFILE}
    } &&
    trap cleanup EXIT &&
    rm -f ${CIDFILE} &&
    docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker image pull endlessplanet/deciphernow:$(git rev-parse --verify HEAD) &&
    docker \
        container \
        create \
        --cidfile ${CIDFILE} \
        --interactive \
        --tty \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        endlessplanet/deciphernow:$(git rev-parse --verify HEAD) &&
    docker container start --interactive $(cat ${CIDFILE})