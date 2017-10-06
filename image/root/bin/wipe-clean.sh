#!/bin/sh

ls -1 ${HOME}/docker/containers | while read FILE
    do
        docker container stop $(cat ${HOME}/docker/containers/${FILE}) &&
            docker container rm --volumes $(cat ${HOME}/docker/containers/${FILE}) &&
            rm -f ${HOME}/docker/containers/${FILE}
    done &&
    ls -1 ${HOME}/docker/networks | while read FILE
    do
        sudo docker networks rm $(cat ${HOME}/docker/networks/${FILE}) &&
            rm -f ${HOME}/docker/networks/${FILE}
    done &&
    ls -1 ${HOME}/docker/volumes | while read FILE
    do
        sudo docker volume rm $(cat ${HOME}/docker/volumes/${FILE}) &&
            rm -f ${HOME}/docker/volumes/${FILE}
    done