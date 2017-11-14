#!/bin/sh

if [ ! -f ${HOME}/docker/networks/salt ]
then
    docker network create --label expiry=$(date --date "${EXPIRY}" +%s) $(uuidgen) > ${HOME}/docker/networks/salt
fi