#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
        --master-branch)
            export MASTER_BRANCH="${2}" &&
                shift 2
        ;;
        --organization-name)
            ORGANIZATION_NAME="${2}" &&
                shift 2
        ;;
        --project-name)
            export PROJECT_NAME="${2}" &&
                shift 2
        ;;
    esac
done &&
    docker-container-create-saltmaster &&
    sleep 15s &&
    if [ ! -f ${HOME}/docker/containers/cloud9-${PROJECT_NAME} ]
    then
        docker-image-build-cloud9 &&
        docker-container-start-sshd &&
        docker-container-start-browser &&
        docker \
            container \
            create \
            --label expiry=$(date --date "${EXPIRY}" +%s) \
            --cidfile ${HOME}/docker/containers/cloud9-${PROJECT_NAME} \
            --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
            --env "PROJECT_NAME=${PROJECT_NAME}" \
            --env "MASTER_BRANCH=${MASTER_BRANCH}" \
            $(cat ${HOME}/docker/images/cloud9) &&
        docker network connect --alias "${PROJECT_NAME}" $(cat ${HOME}/docker/networks/regular) $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) &&
        docker-network-start-saltmaster &&
        docker network connect $(cat ${HOME}/docker/networks/salt) $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) &&
        docker container start $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) &&
        ID_RSA_PUB=$(docker \
            container \
            exec \
            --interactive \
            --tty \
            --user root \
            $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) \
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
            $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) \
                sh \
                /opt/docker/src/sbin/tunnel2sshd.sh \
                "${PORT}" &&
        docker \
            container \
            exec \
            --detach \
            --user root \
            $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) \
                sh \
                /opt/docker/src/sbin/tunnel2cloud9.sh \
                "${PORT}" &&
        docker container exec --interactive --tty --user root $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo sh /opt/docker/src/sbin/salt-minion.sh ${PROJECT_NAME} &&
        sleep 10s &&
        docker container exec --interactive --tty --user root $(cat ${HOME}/docker/containers/cloud9-saltstack) git -C /opt/docker/workspace/${PROJECT_NAME}/repo salt-key --accept-all --yes ${PROJECT_NAME}
    fi