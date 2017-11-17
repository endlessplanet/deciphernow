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
    if [ ! -f ${HOME}/docker/containers/cloud9-${PROJECT_NAME} ]
    then
        docker-container-start-cloud9 --host-name ${PROJECT_NAME} &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) mkdir /opt/docker/workspace/${PROJECT_NAME}/repo &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo init &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo config user.name "${LDAP_USERNAME}" &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo config user.email "${LDAP_EMAIL}" &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo remote add upstream ssh://upstream.gitlab/${ORGANIZATION_NAME}/${PROJECT_NAME}.git &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo remote set-url --push upstream no_push &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo remote add origin ssh://origin.gitlab/${LDAP_USERNAME}/${PROJECT_NAME}.git &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo fetch upstream ${MASTER_BRANCH} &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo checkout upstream/${MASTER_BRANCH} &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) git -C /opt/docker/workspace/${PROJECT_NAME}/repo checkout -b scratch/$(uuidgen) &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/cloud9-${PROJECT_NAME}) ln -sf /opt/docker/bin/post-commit /opt/docker/workspace/${PROJECT_NAME}/repo/.git/hooks &&
            true
    fi