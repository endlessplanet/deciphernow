#!/bin/sh

cleanup(){
    docker container stop $(cat cidfile) &&
        docker container rm --volumes $(cat cidfile) &&
        rm -f cidfile
} &&
    trap cleanup EXIT &&
    docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker image pull endlessplanet/deciphernow:$(git rev-parse --verify HEAD) &&
    docker \
        container \
        create \
        --interactive \
        --tty \
        --env NETWORK="${1}" \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        endlessplanet/deciphernow:$(git rev-parse --verify HEAD) &&
    docker container start --interactive $(cat cidfile)