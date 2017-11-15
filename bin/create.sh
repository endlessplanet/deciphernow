#!/bin/sh

docker \
    container \
    create \
    --interactive \
    --tty \
    --rm \
    --env DISPLAY \
    --env EXPIRY="now + 1 hour" \
    --env-file public.env \
    --env CHIMERA_ID_RSA="$(cat chimera_id_rsa)" \
    --env UPSTREAM_ID_RSA="$(cat upstream_id_rsa)" \
    --env ORIGIN_ID_RSA="$(cat origin_id_rsa)" \
    --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
    --name deciphernow \
    endlessplanet/deciphernow:$(git rev-parse HEAD)