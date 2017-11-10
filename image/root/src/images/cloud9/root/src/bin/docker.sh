#!/bin/sh

sudo \
    /usr/bin/docker \
    container \
    run \
    --interactive \
    --tty \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --env DISPLAY \
    docker:17.10.0 \
        "${@}"