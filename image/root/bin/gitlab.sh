#!/bin/sh

ADVENTURE_NAME="${1}" &&
    ORGANIZATION="${2}" &&
    REPOSITORY="${3}" &&
    SHELL_CIDFILE=$(mktemp ${HOME}/docker/containers/shell-${ADVENTURE_NAME}-XXXXXXXX) &&
    CLOUD9_CIDFILE=${SHELL_CIDFILE} &&
    sudo docker volume create > ${HOME}/docker/volumes/workspace-${ADVENTURE_NAME} &&
    rm --force ${SHELL_CIDFILE} &&
    sudo \
        docker \
        container \
        create \
        --cidfile ${CLOUD9_CIDFILE} \
        --env SSHD_CONTAINER=$(cat ${HOME}/docker/containers/sshd) \
        --env SHELL_CONTAINER=$(cat ${SHELL_CIDFILE}) \
        --volume /var/run/docker.sock:/var/run/docker.sock:ro \
        --volume $(cat ${HOME}/docker/volumes/workspace-${ADVENTURE_NAME}):/workspace/${ADVENTURE_NAME} \
        endlessplanet/cloud9:8d446e5b98f4ca4344877fa079df32a08415fd0b 
    start-cloud9 "${ADVENTURE_NAME}" "${SHELL_CIDFILE}" &&
    echo "${ORIGIN_ID_RSA}" | sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) tee /home/user/.ssh/origin_id_rsa &&
    echo "${UPSTREAM_ID_RSA}" | sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) tee /home/user/.ssh/upstream_id_rsa &&
    echo "${REPORT_ID_RSA}" | sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) tee /home/user/.ssh/report_id_rsa &&
    sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) chmod 0600 /home/user/.ssh/report_id_rsa &&
    sudo docker container cp /opt/docker/config.ssh.txt $(cat ${SHELL_CIDFILE}):/home/user/.ssh/config &&
    ssh-keyscan gitlab.363-283.io | sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) tee /home/user/.ssh/known_hosts &&
    sudo docker \
        container \
        exec \
        --interactive \
        \
        $(cat ${SHELL_CIDFILE}) \
            chmod 0600 \
            /home/user/.ssh/origin_id_rsa \
            /home/user/.ssh/upstream_id_rsa \
            /home/user/.ssh/report_id_rsa \
            /home/user/.ssh/report_id_rsa \
            /home/user/.ssh/known_hosts &&
    sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} init &&
    sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} remote add origin ssh://origin/${LDAP_USERNAME}/${REPOSITORY}.git &&
    sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} remote add upstream ssh://upstream/${ORGANIZATION}/${REPOSITORY}.git &&
    sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} remote set-url --push upstream no_push &&
    sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} remote add report ssh://report/${ORGANIZATION}/${REPOSITORY}.git &&
    sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} config user.name "${LDAP_USERNAME}" &&
    sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} config user.email "${LDAP_EMAIL}"
    