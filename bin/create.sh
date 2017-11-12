#!/bin/sh

docker \
    container \
    create \
    --interactive \
    --tty \
    --rm \
    --env DISPLAY \
    --env EXPIRY="now + 1 hour" \
    --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
    --name deciphernow \
    endlessplanet/deciphernow:$(git rev-parse HEAD)