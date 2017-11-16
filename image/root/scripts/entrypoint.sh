#!/bin/sh

trap /opt/docker/bin/docker-system-prune-expired EXIT &&
    bash