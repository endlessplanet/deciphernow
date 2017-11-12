#!/bin/sh

ls -1 ${HOME}/docker/images | while read IMAGE
do
    docker images $(cat ${HOME}/docker/image/${IMAGE}) &&
done