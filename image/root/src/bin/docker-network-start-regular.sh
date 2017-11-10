#!/bin/sh

if [ ! -f ${HOME}/docker/networks/regular ]
then
    docker network create $(uuidgen) > ${HOME}/docker/networks/regular
fi