#!/bin/sh

ls -1 ${HOME}/docker/containers | while read CONTAINER
do
    docker container stop $(cat ${HOME}/docker/containers/${CONTAINER}) &&
        docker container rm --volumes $(cat ${HOME}/docker/containers/${CONTAINER})
done