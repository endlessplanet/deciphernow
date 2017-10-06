#!/bin/sh

REGISTRATION_TOKEN=${1} &&
    DIND=$(mktemp ${HOME}/docker/containers/dind-XXXXXXXX) &&
    RUNN=$(mktemp ${HOME}/docker/containers/runner-XXXXXXXX) &&
    NETW=$(mktemp ${HOME}/docker/networks/runner-XXXXXXXX) &&
    docker image pull docker:17.09.0-dind &&
    docker image pull gitlab/gitlab-runner:v1.11.2 &&
    docker network create $(uuidgen) > ${NETW} &&
    rm -f ${DIND} ${RUNN}
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
        --cidfile ${RUNN} \
        gitlab/gitlab-runner:v1.11.2 &&
    docker \
        network \
        connect \
        --alias dind \
        $(cat ${NETW}) \
        $(cat ${DIND}) &&
    docker \
        network \
        connect \
        $(cat ${NETW}) \
        $(cat ${RUNN}) &&
    docker \
        container \
        start \
        $(cat ${DIND}) \
        $(cat ${RUNN}) &&
    docker \
        container \
        exec \
        --interactive \
        --tty \
        $(cat ${RUNN}) \
        gitlab-runner \
            register \
            --non-interactive \
            --registration-token ${REGISTRATION_TOKEN} \
            --run-untagged \
            --name "proprietary" \
            --limit 1 \
            --url https://gitlab.363-283.io/ci \
            --executor docker \
            --docker-host tcp://dind_1:2376 \
            --docker-image docker:17.09.0-ce-dind