#!/bin/sh

docker-container-prune-expired &&
    docker-image-prune-expired &&
    docker-network-prune-expired &&
    docker-volume-prune-expired