#!/bin/sh

if [ ! -f ${HOME}/docker/networks/vpn ]
then
    docker network create --label expiry=$(date --date "${EXPIRY}" +%s) $(uuidgen) > ${HOME}/docker/networks/vpn
fi