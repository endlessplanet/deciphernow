#!/bin/sh

SHELL_CIDFILE=$(mktemp ${HOME}/docker/containers/shell-XXXXXXXX) &&
    CLOUD9_CIDFILE=$(mktemp ${HOME}/docker/containers/cloud9-XXXXXXXX) &&
    rm --force ${SHELL_CIDFILE} ${CLOUD9_CIDFILE} &&
    docker container create 