#!/bin/sh

trap /opt/docker/bin/docker-container-prune-expired EXIT &&
    bash