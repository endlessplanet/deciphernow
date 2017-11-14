#!/bin/sh

PROJECT_NAME=${1} &&
    dnf update --assumeyes &&
    dnf install --assumeyes procps-ng &&
    dnf install --assumeyes curl &&
    dnf install --assumeyes salt-minion &&
    echo ${PROJECT_NAME} > /etc/salt/minion_id &&
    dnf clean all &&
    /usr/bin/salt-minion