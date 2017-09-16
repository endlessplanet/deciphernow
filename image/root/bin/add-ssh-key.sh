#!/bin/sh

SHELL_CONTAINER="${1}" &&
    echo ${ORIGIN_ID_RSA} | docker container exec --interactive ${1} tee /home/user/.ssh/origin_id_rsa &&
    echo ${UPSTREAM_ID_RSA} | docker container exec --interactive ${1} tee /home/user/.ssh/upstream_id_rsa &&
    echo ${REPORT_ID_RSA} | docker container exec --interactive ${1} tee /home/user/.ssh/report_id_rsa &&
    docker container exec --interactive --tty ${1} chmod 0600 /home/user/.ssh/origin_id_rsa /home/user/.ssh/upstream_id_rsa /home/user/.ssh/origin_id_rsa