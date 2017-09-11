#!/bin/sh

PROJECT_NAME=${1} &&
    docker \
        container \
        start 
        $(docker inspect --format "{{ index .Config.Env 1 }}" $(cat ${HOME}/docker/containers/${PROJECT_NAME})) &&
    docker \
        container \
        start \
        $(cat ${HOME}/docker/containers/${PROJECT_NAME})