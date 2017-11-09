#!/bin/sh

docker \
    container \
    create \
    --interactive \
    --tty \
    --rm \
    --env DISPLAY \
    --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
    --name decipernow \
    endlessplanet/deciphernow:$(git rev-parse HEAD)