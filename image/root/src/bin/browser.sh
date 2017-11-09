#!/bin/sh

docker \
    container \
    create \
    --cidfile browser.cid \
    --mount type=bind,source=/tmp/.X11-unix,destination=/tmp/.X11-unix,readonly=true \
    --env DISPLAY \
    $(docker image ls --quiet --filter label=title=browser | head -n 1) &&
    docker container start $(cat browser.cid)