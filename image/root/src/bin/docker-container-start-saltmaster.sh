#!/bin/sh

export ORGANIZATION_NAME=chimera &&
    export PROJECT_NAME=saltstack &&
        docker-container-start-gitlab &&
        docker container exec --interactive --tty --user root $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) sh /opt/docker/src/sbin/salt-master.sh &&
        true
    fi