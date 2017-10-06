#!/bin/sh

for REGISTRATION_TOKEN in "${@}"
do
    docker \
        container \
        exec \
        --interactive \
        --tty \
        $(cat ${HOME}/docker/containers/gitlab-runner) \
            gitlab-runner \
            register \
            --non-interactive \
            --registration-token "${REGISTRATION_TOKEN}" \
            --run-untagged \
            --name "$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)" \
            --limit 1 \
            --url https://gitlab.363-283.io/ci \
            --executor docker \
            --docker-host tcp://dind:2376 \
            --docker-image docker:17.09.0-ce-dind \
            --docker-volumes /var/run/docker.sock:/var/run/docker.sock
done