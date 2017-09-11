#!/bin/sh

docker \
    container \
    create \
    --env ID_RSA="$(cat ${HOME}/.ssh/id_rsa)" \
    --env KNOWN_HOSTS="$(cat ${HOME}/.ssh/known_hosts)" \
    --env LDAP_USERNAME="emory.merryman" \
    --env LDAP_EMAIL="emory.merryman@deciphernow.com" \
    endlessplanet/deciphernow &&
    docker container start