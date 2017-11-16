#!/bin/sh

mkdir /opt/docker/workspace/${HOST_NAME} &&
    node /opt/docker/c9sdk/server.js --listen 127.0.0.1 -w /opt/docker/workspace/${HOST_NAME} "${@}"