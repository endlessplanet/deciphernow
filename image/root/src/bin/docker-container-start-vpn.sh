#!/bin/sh

if [ ! -f ${HOME}/docker/containers/vpn ]
then
    docker-image-build-vpn &&
        docker \
            container \
            create \
            --cidfile ${HOME}/docker/containers/vpn \
            --label expiry=$(date --date "${EXPIRY}" +%s) \
            $(cat ${HOME}/docker/images/sshd) &&
            docker-network-start-vpn &&
            docker network connect $(cat ${HOME}/docker/networks/vpn) $(cat ${HOME}/docker/containers/vpn) &&
            docker container start $(cat ${HOME}/docker/containers/vpn)
fi