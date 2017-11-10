#!/bin/sh

node /opt/docker/c9sdk/server.js --listen 0.0.0.0 -w /opt/docker/workspace --auth user:password "${@}"