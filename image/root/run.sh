#!/bin/sh

dnf update --assumeyes &&
    dnf install --assumeyes dnf-plugins-core &&
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &&
    dnf update --assumeyes &&
    dnf install --assumeyes docker-common docker-latest &&
    dnf update --assumeyes &&
    adduser user &&
    dnf install --assumeyes sudo openssh-clients &&
    cp /opt/docker/user.sudo /etc/sudoers.d/user &&
    chmod 0444 /etc/sudoers.d/user &&
    dnf update --assumeyes &&
    dnf clean all