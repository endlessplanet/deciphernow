#!/bin/sh

if [ ! -f ${HOME}/docker/networks/regular ]
then
    docker network create --label expiry=$(date --date "${EXPIRY}" +%s) $(uuidgen) > ${HOME}/docker/networks/salt
fi