#!/bin/sh

if [ ! -f ${HOME}/docker/volumes/home ]
then
    docker volume create --label expiry=$(date --date "${EXPIRY}" +%s) > ${HOME}/docker/volumes/chimera_dot_ssh &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 mkdir user &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 mkdir user/.ssh &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 chmod 0700 user/.ssh &&
        echo "${CHIMERA_ID_RSA}" | docker container run --interactive --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 tee user/.ssh/id_rsa &&
        sed -e "s#\${LDAP_USERNAME}#${LDAP_USERNAME}#" /opt/docker/ssh_config.txt | docker container run --interactive --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 tee user/.ssh/config &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 chmod 0600 user/.ssh/id_rsa user/.ssh/config &&
        ssh-keyscan -p 2252 gitlab.363-283.io | docker container run --interactive --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 tee user/.ssh/known_hosts &&
        ssh-keyscan -p 2233 54.173.144.101 | docker container run --interactive --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 tee user/.ssh/known_hosts &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 chmod 0644 user/.ssh/known_hosts &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 chown -R 1000:1000 user
fi