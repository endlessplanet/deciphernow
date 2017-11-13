#!/bin/sh

if [ ! -f ${HOME}/docker/containers/cloud9-${1} ]
then
    docker-image-build-cloud9 &&
    docker-container-start-sshd &&
    docker-container-start-browser &&
    docker \
        container \
        create \
        --label expiry=$(date --date "${EXPIRY}" +%s) \
        --cidfile ${HOME}/docker/containers/cloud9-${1} \
        --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
        $(cat ${HOME}/docker/images/cloud9) &&
    docker network connect --alias "${1}" $(cat ${HOME}/docker/networks/regular) $(cat ${HOME}/docker/containers/cloud9-${@}) &&
    docker container start $(cat ${HOME}/docker/containers/cloud9-${1}) &&
    ID_RSA_PUB=$(docker \
        container \
        exec \
        --interactive \
        --tty \
        --user root \
        $(cat ${HOME}/docker/containers/cloud9-${1}) \
            sh \
            /opt/docker/src/sbin/tunnel-init.sh) &&
    echo ID_RSA_PUB=${ID_RSA_PUB} &&
    PORT=$(docker \
        container \
        exec \
        --interactive \
        --tty \
        $(cat ${HOME}/docker/containers/sshd) \
            sh \
            /opt/docker/src/sbin/reserve.sh \
            "${ID_RSA_PUB}" | head -n 1) &&
    echo PORT=${PORT} &&
    sleep 10s &&
    docker \
        container \
        exec \
        --detach \
        --user root \
        $(cat ${HOME}/docker/containers/cloud9-${1}) \
            sh \
            /opt/docker/src/sbin/tunnel2sshd.sh \
            "${PORT}" &&
    docker \
        container \
        exec \
        --detach \
        --user root \
        $(cat ${HOME}/docker/containers/cloud9-${1}) \
            sh \
            /opt/docker/src/sbin/tunnel2cloud9.sh \
            "${PORT}"
fi