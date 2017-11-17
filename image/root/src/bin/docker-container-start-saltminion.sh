#!/bin/sh

while [ ${#} -gt 0 ]
do
    case ${1} in
        --minion-name)
            export MINION_NAME="${2}" &&
                shift 2
        ;;
    esac
done &&
    docker-container-start-saltmaster &&
    export HOST_NAME=${MINION_NAME} &&
    docker-container-start-cloud9 ${@} &&
    docker network connect --alias "${MINION_NAME}" $(cat ${HOME}/docker/networks/regular) $(cat ${HOME}/docker/containers/cloud9-${MINION_NAME}) &&
    docker network connect $(cat ${HOME}/docker/networks/salt) $(cat ${HOME}/docker/containers/cloud9-${MINION_NAME})