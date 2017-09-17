#!/bin/sh

ADVENTURE_NAME="${1}" &&
    ORGANIZATION="${2}" &&
    REPOSITORY="${3}" &&
    SHELL_CIDFILE=$(mktemp ${HOME}/docker/containers/shell-${ADVENTURE_NAME}-XXXXXXXX) &&
    start-cloud9 "${ADVENTURE_NAME}" "${SHELL_CIDFILE}" &&
    echo "${ORIGIN_ID_RSA}" | sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) tee /home/user/.ssh/origin_id_rsa &&
    echo "${UPSTREAM_ID_RSA}" | sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) tee /home/user/.ssh/upstream_id_rsa &&
    echo "${REPORT_ID_RSA}" | sudo docker container exec --interactive $(cat ${SHELL_CIDFILE}) tee /home/user/.ssh/report_id_rsa &&
    sudo docker container exec --interactive --tty $(cat ${SHELL_CIDFILE}) chmod 0600 /home/user/.ssh/report_id_rsa &&
    sudo docker container cp /opt/docker/config.ssh.txt $(cat ${SHELL_CIDFILE}):/home/user/.ssh/config &&
    ssh-keyscan gitlab.363-283.io | sudo docker container exec --interactive --tty $(cat ${SHELL_CIDFILE}) tee /home/user/.ssh/known_hosts &&
    sudo docker \
        container \
        exec \
        --interactive \
        --tty \
        $(cat ${SHELL_CIDFILE}) \
            chmod 0600 \
            /home/user/.ssh/origin_id_rsa \
            /home/user/.ssh/upstream_id_rsa \
            /home/user/.ssh/report_id_rsa \
            /home/user/.ssh/report_id_rsa \
            /home/user/.ssh/known_hosts &&
    sudo docker container exec --interactive --tty $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} init &&
    sudo docker container exec --interactive --tty $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} remote add origin ssh://origin/${LDAP_USERNAME}/notification-engine.git &&
    sudo docker container exec --interactive --tty $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} remote add upstream ssh://origin/${ORGANIZATION}/${REPOSITORY}.git &&
    sudo docker container exec --interactive --tty $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} remote set-url --push upstream no_push &&
    sudo docker container exec --interactive --tty $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} remote add report ssh://origin/${ORGNAIZATION}/${REPOSITORY}.git &&
    sudo docker container exec --interactive --tty $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} config user.name "${LDAP_USERNAME}" &&
    sudo docker container exec --interactive --tty $(cat ${SHELL_CIDFILE}) git -C /workspace/${ADVENTURE_NAME} config user.email "${LDAP_EMAIL}"
    