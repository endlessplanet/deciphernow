#!/bin/sh

cleanup(){
    sh /opt/docker/cleanup.sh
} &&
    trap cleanup EXIT &&
	docker network create $(uuidgen) > ${HOME}/docker/networks/default &&
    docker volume create > ${HOME}/docker/volumes/homey &&
	docker \
		container \
		create \
		--cidfile ${HOME}/docker/containers/chromium \
		--privileged \
		--tty \
		--shm-size 256m \
		--env DISPLAY \
		--env TARGETUID=1000 \
		--env XDG_RUNTIME_DIR=/run/user/1000 \
		--volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
		--volume /run/user/1000/pulse:/run/user/1000/pulse:ro \
		--volume /etc/machine-id:/etc/machine-id:ro \
		--volume /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket:ro \
		--volume /var/lib/dbus:/var/lib/dbus:ro \
		--volume /tmp:/tmp \
		--volume /home/aaja0ify:/home/chromium/.config/pulse:ro \
		--volume $(cat ${HOME}/docker/volumes/homey):/data \
		--volume /dev/video0:/dev/video:ro \
		urgemerge/chromium-pulseaudio &&
	docker network connect $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/chromium) &&
	docker \
		container \
		create \
		--tty \
		--cidfile ${HOME}/docker/containers/sshd \
		endlessplanet/sshd &&
	docker network connect --alias sshd $(cat ${HOME}/docker/networks/default) $(cat ${HOME}/docker/containers/sshd) &&
    sh /opt/docker/create-cloud9.sh cte object-drive-ui&&
    bash