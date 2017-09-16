#!/bin/sh

echo ${ORIGIN_ID_RSA} | docker container exec --interactive $(cat ${HOME}/docker/containers/${ADVENTURE_NAME}) tee /home/user/.ssh/origin_id_rsa &&
    docker container exec --interactive --tty $(cat ${HOME}/docker)