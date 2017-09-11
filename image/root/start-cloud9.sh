#!/bin/sh

PROJECT_NAME=${1} &&
    docker \
        container \
        start 
        $(docker inspect --format "{{ index .Config.Env 0 }}" $(cat ${HOME}/docker/containers/${PROJECT_NAME}) | cut -f 2 -d "=") &&
    docker \
        container \
        start \
        $(cat ${HOME}/docker/containers/${PROJECT_NAME})