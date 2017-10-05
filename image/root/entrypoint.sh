#!/bin/sh

bash 
# cleanup() {
#     ls -1 ${HOME}/docker/containers | while read FILE
#     do
#         docker container stop $(cat ${HOME}/docker/containers/${FILE}) &&
#             docker container rm --volumes $(cat ${HOME}/docker/containers/${FILE}) &&
#             rm --force ${HOME}/docker/containers/${FILE}
#     done &&
#     ls -1 ${HOME}/docker/volumes | while read FILE
#     do
#         sudo docker volume rm $(cat ${HOME}/docker/volumes/${FILE}) &&
#             rm --force ${HOME}/docker/volumes/${FILE}
#     done
# } &&
#     trap cleanup EXIT &&
#     sudo docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
#     sudo docker image pull ${SSHD_IMAGE} &&
#     sudo docker image pull ${CLOUD9_IMAGE} &&
#     sudo docker container create --cidfile ${HOME}/docker/containers/sshd endlessplanet/sshd:ca675205de9d945aac60f35885ae75a71f9de123 &&
#     sudo docker network connect --alias sshd entrypoint_default $(cat ${HOME}/docker/containers/sshd) &&
#     sudo docker container start $(cat ${HOME}/docker/containers/sshd) &&
    