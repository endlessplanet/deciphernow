#!/bin/sh

trap docker-system-prune-expired EXIT &&
    bash