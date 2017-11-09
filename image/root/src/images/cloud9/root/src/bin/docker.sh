#!/bin/sh

sudo /usr/bin/docker container run --type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true docker:17.10.0 "${@}"