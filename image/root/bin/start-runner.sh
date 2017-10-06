#!/bin/sh

gitlab-runner \
    register \
    --non-interactive \
    --registration-token "${1}" \
    --run-untagged \
    --name "${2}" \
    --limit 1 \
    --url https://gitlab.363-283.io/ci \
    --executor docker \
    --docker-host tcp://dind:2376 \
    --docker-image docker:17.09.0-ce-dind \
    --docker-volumes /var/run/docker.sock:/var/run/docker.sock