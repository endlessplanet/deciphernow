#!/bin/sh

GROUP_NAME=${1} &&
    PROJECT_NAME=${2} &&
    SHELL_CIDFILE=$(mktemp ${HOME}/docker/containers/shell.XXXXXXXX) &&
    export ORIGIN=ssh://git@gitlab.363-283.io:2252/${LDAP_USERNAME}/${PROJECT_NAME}.git
    export UPSTREAM=ssh://git@gitlab.363-283.io:2252/${GROUP_NAME}/${PROJECT_NAME}.git
    export REPORT=ssh://git@gitlab.363-283.io:2252/${GROUP_NAME}/${PROJECT_NAME}.git
    rm SHELL_CIDFILE &&
	docker \
		container \
		create \
		--cidfile ${SHELL_CIDFILE} \
		--env PROJECT_NAME="${PROJECT_NAME}" \
		--env ID_RSA="${ID_RSA}" \
		--env KNOWN_HOSTS="${KNOWN_HOSTS}" \
		--env USERNAME="${LDAP_USERNAME}" \
		--env EMAIL="${LDAP_EMAIL}" \
		--env ORIGIN= \
		--env UPSTREAM= \
		--env REPORT= \
		--env DISPLAY="${DISPLAY}" \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		endlessplanet/shell &&
	docker network connect $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/shell) &&
    docker \
        inspect \
        --format "{{ range .Mounts }}{{ if eq .Destination \"/workspace\" }}{{ .Name }}{{ end }}{{ end }}" \
        $(cat ${HOME}/docker/containers/shell) > ${HOME}/docker/volumes/workspace &&
    docker \
		container \
		create \
		--cidfile ${HOME}/docker/containers/${PROJECT_NAME} \
		--env CONTAINER_ID=$(cat ${SHELL_CIDFILE}) \
		--env SSHD_CONTAINER=$(cat ${HOME}/docker/containers/sshd) \
		--volume /var/run/docker.sock:/var/run/docker.sock:ro \
		--volume $(cat ${HOME}/docker/volumes/workspace):/workspace \
		endlessplanet/cloud9 &&
	docker network connect --alias ${PROJECT_NAME} $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/${PROJECT_NAME})