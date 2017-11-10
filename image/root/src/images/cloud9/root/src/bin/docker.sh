#!/bin/sh

sudo \
    /usr/bin/docker \
    container \
    run \
    --interactive \
    --tty \
    --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
    docker:17.10.0 "${@}"