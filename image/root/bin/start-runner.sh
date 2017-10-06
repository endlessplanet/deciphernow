#!/bin/sh

REGISTRATION_TOKEN=${1} &&
    docker image pull docker:17.09.0-dind &&
    docker image pull gitlab/gitlab-runner:v1.11.2 &&
    docker network create $(uuidgen) > ${HOME}/docker/networks/runner &&
    docker \
        container \
        create \
        --cidfile ${HOME}/docker/containers/runner-dind \
        --privileged \
        docker:17.09.0-dind \
            --host tcp://0.0.0.0:2376 &&
    docker \
        container \
        create \
        --cidfile ${HOME}/docker/containers/runner \
        gitlab/gitlab-runner:v1.11.2 &&
    docker network connect --alias dind $(cat ${HOME}/docker/networks/runner) $(cat ${HOME}/docker/containers/runner-dind-1) &&
    docker network connect $(cat ${HOME}/docker/networks/runner) $(cat ${HOME}/docker/containers/runner) &&
    docker container start $(cat ${HOME}/docker/containers/runner-dind) $(cat ${HOME}/docker/containers/runner) &&
    docker \
        container \
        exec \
        --interactive \
        --tty \
        $(cat ${HOME}/docker/containers/runner) \
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
            --docker-image docker:17.09.0-ce-dind \