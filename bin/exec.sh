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
        --cidfile cidfile \
        --interactive \
        --tty \
        --env NETWORK="${1}" \
        --env DISPLAY \
        --env DOCKERHUB_USERNAME \
        --env DOCKERHUB_PASSWORD \
        --env LDAP_USERNAME \
        --env LDAP_EMAIL \
        --env ORIGIN_ID_RSA="$(cat ~/.ssh/origin_id_rsa)" \
        --env UPSTREAM_ID_RSA="$(cat ~/.ssh/upstream_id_rsa)" \
        --env REPORT_ID_RSA="$(cat ~/.ssh/report_id_rsa)" \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        endlessplanet/deciphernow:$(git rev-parse --verify HEAD) &&
    docker container start --interactive $(cat cidfile)