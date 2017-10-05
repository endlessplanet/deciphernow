#!/bin/sh

ORGANIZATION="${1}" &&
    REPOSITORY="${2}" &&
    ADVENTURE="${3}" &&
    CIDFILE=$(mktemp ${HOME}/docker/containers) &&
    rm ${CIDFILE} &&
    docker \
        container \
        create \
        --cidfile ${CIDFILE} \
        --env SSHD_CONTAINER=$(cat ${HOME}/docker/containers/sshd) \
        --env ADVENTURE \
        ${CLOUD9_IMAGE} &&
    docker container start $(cat ${CIDFILE}) &&
    echo "${ORIGIN_ID_RSA}" | docker container exec --interactive $(cat ${CIDFILE}) tee /home/user/.ssh/origin_id_rsa &&
    echo "${UPSTREAM_ID_RSA}" | docker container exec --interactive $(cat ${CIDFILE}) tee /home/user/.ssh/upstream_id_rsa &&
    echo "${REPORT_ID_RSA}" | docker container exec --interactive $(cat ${CIDFILE}) tee /home/user/.ssh/report_id_rsa &&
    echo "${KNOWN_HOSTS}" | docker container exec --interactive $(cat ${CIDFILE}) tee /home/user/.ssh/report_id_rsa &&
    docker container exec --interactive $(cat ${CIDFILE}) chmod 0600 /home/user/.ssh/origin_id_rsa /home/user/.ssh/upstream_id_rsa /home/user/.ssh/report_id_rsa &&
    docker container exec --interactive $(cat ${CIDFILE}) chmod 0664 /home/user/.ssh/known_hosts &&
    docker container cp /opt/docker/config.ssh.txt $(cat ${CIDFILE}):/home/user/.ssh/config &&
    docker container exec --interactive $(cat ${CIDFILE}) mkdir /workspace/${ADVENTURE_NAME}/project /workspace/${ADVENTURE_NAME}/salt &&
    docker container exec --interactive $(cat ${CIDFILE}) git -C /workspace/${ADVENTURE_NAME}/project init &&
    docker container exec --interactive $(cat ${CIDFILE}) git -C /workspace/${ADVENTURE_NAME}/project remote add origin ssh://origin/${LDAP_USERNAME}/${REPOSITORY}.git &&
    docker container exec --interactive $(cat ${CIDFILE}) git -C /workspace/${ADVENTURE_NAME}/project remote add upstream ssh://upstream/${ORGANIZATION}/${REPOSITORY}.git &&
    docker container exec --interactive $(cat ${CIDFILE}) git -C /workspace/${ADVENTURE_NAME}/project remote set-url --push upstream no_push &&
    docker container exec --interactive $(cat ${CIDFILE}) git -C /workspace/${ADVENTURE_NAME}/project remote add report ssh://report/${ORGANIZATION}/${REPOSITORY}.git &&
    docker container exec --interactive $(cat ${CIDFILE}) git -C /workspace/${ADVENTURE_NAME}/project config user.name "${LDAP_USERNAME}" &&
    docker container exec --interactive $(cat ${CIDFILE}) git -C /workspace/${ADVENTURE_NAME}/project config user.email "${LDAP_EMAIL}" &&
    docker container exec --interactive $(cat ${CIDFILE}) ln --symbolic --force /home/user/bin/post-commit /workspace/${ADVENTURE_NAME}/project/.git/hooks &&
    docker container exec --interactive $(cat ${CIDFIlE}) git -C /workspace/${ADVENTURE_NAME}/salt init &&
    docker container exec --interactive $(cat ${CIDFIlE}) git -C /workspace/${ADVENTURE_NAME}/salt remote add origin ssh://origin/${LDAP_USERNAME}/${REPOSITORY}.git &&
    docker container exec --interactive $(cat ${CIDFIlE}) git -C /workspace/${ADVENTURE_NAME}/salt remote add upstream ssh://upstream/${ORGANIZATION}/${REPOSITORY}.git &&
    docker container exec --interactive $(cat ${CIDFIlE}) git -C /workspace/${ADVENTURE_NAME}/salt remote set-url --push upstream no_push &&
    docker container exec --interactive $(cat ${CIDFIlE}) git -C /workspace/${ADVENTURE_NAME}/salt remote add report ssh://report/${ORGANIZATION}/${REPOSITORY}.git &&
    docker container exec --interactive $(cat ${CIDFIlE}) git -C /workspace/${ADVENTURE_NAME}/salt config user.name "${LDAP_USERNAME}" &&
    docker container exec --interactive $(cat ${CIDFIlE}) git -C /workspace/${ADVENTURE_NAME}/salt config user.email "${LDAP_EMAIL}" &&
    docker container exec --interactive $(cat ${CIDFIlE}) ln --symbolic --force /home/user/bin/post-commit /workspace/${ADVENTURE_NAME}/salt/.git/hooks
    