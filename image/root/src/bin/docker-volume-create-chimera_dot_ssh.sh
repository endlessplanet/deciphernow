#!/bin/sh

if [ ! -f ${HOME}/docker/volumes/chimera_dot_ssh ]
then
    docker volume create --label expiry=$(date --date "${EXPIRY}" +%s) > ${HOME}/docker/volumes/chimera_dot_ssh &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 mkdir user &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 mkdir user/.ssh &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 chmod 0700 user/.ssh &&
        echo "${CHIMERA_ID_RSA}" | docker container run --interactive --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 tee user/.ssh/id_rsa &&
        (cat <<EOF
HostName chm-bastion
HostName 54.173.144.101
Port 2233
User ${LDAP_USERNAME}
IdentityFile ~/.ssh/id_rsa
ControlMaster auto
ControlPath ~/.ssh/chm-ctrl_path-%h-%p-%r
LocalForward 0.0.0.0:8080 s3.amazonaws.com:80
LocalForward 0.0.0.0:8443  s3.amazonaws.com:443
EOF
        ) | docker container run --interactive --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 tee user/.ssh/config &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 chmod 0600 user/.ssh/id_rsa user/.ssh/config &&
        ssh-keyscan -p 2233 54.173.144.101 | docker container run --interactive --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 tee user/.ssh/known_hosts &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 chmod 0644 user/.ssh/id_rsa user/.ssh/known_hosts &&
        docker container run --interactive --tty --rm --mount type=volume,source=$(cat ${HOME}/docker/volumes/chimera_dot_ssh),destination=/home --workdir /home alpine:3.4 chown -R 1000:1000 user
fi