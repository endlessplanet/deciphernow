#!/bin/sh

docker \
    volume \
    create \
    --label deciphernow.name="${1}" \
    --label deciphernow.expiry="${2}"