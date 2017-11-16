#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
        --host-name)
            export HOST_NAME="${2}" &&
                shift 2
        ;;
    esac
done &&
    if [ ! -f ${HOME}/docker/containers/cloud9-${HOST_NAME} ]
    then
        docker-image-build-cloud9 &&
        docker-container-start-sshd &&
        docker-volume-create-home &&
        docker-container-start-browser &&
        docker \
            container \
            create \
            --label expiry=$(date --date "${EXPIRY}" +%s) \
            --cidfile ${HOME}/docker/containers/cloud9-${HOST_NAmE} \
            --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
            --mount type=volume,source=$(cat ${HOME}/docker/volumes/home),destination=/home \
            --env "HOST_NAME=${HOST_NAME}" \
            --env "MASTER_BRANCH=${MASTER_BRANCH}" \
            $(cat ${HOME}/docker/images/cloud9) &&
        docker network connect --alias "${HOST_NAME}" $(cat ${HOME}/docker/networks/regular) $(cat ${HOME}/docker/containers/cloud9-${HOST_NAME}) &&
        docker container start $(cat ${HOME}/docker/containers/cloud9-${HOST_NAME}) &&
        ID_RSA_PUB=$(docker \
            container \
            exec \
            --interactive \
            --tty \
            --user root \
            $(cat ${HOME}/docker/containers/cloud9-${HOST_NAME}) \
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
                "${ID_RSA_PUB}" | xargs echo -n) &&
        echo PORT=${PORT} &&
        docker \
            container \
            exec \
            --detach \
            --user root \
            $(cat ${HOME}/docker/containers/cloud9-${HOST_NAME}) \
                sh \
                /opt/docker/src/sbin/tunnel2sshd.sh \
                "${PORT}" &&
        docker \
            container \
            exec \
            --detach \
            --user root \
            $(cat ${HOME}/docker/containers/cloud9-${HOST_NAME}) \
                sh \
                /opt/docker/src/sbin/tunnel2cloud9.sh \
                "${PORT}"
    fi