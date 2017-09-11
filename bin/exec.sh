#!/bin/sh

docker \
    container \
    create \
    --cidfile ${PWD}/cidfile \
    --interactive \
    --tty \
    --env ID_RSA="$(cat ${HOME}/.ssh/id_rsa)" \
    --env KNOWN_HOSTS="$(cat ${HOME}/.ssh/known_hosts)" \
    --env LDAP_USERNAME="emory.merryman" \
    --env LDAP_EMAIL="emory.merryman@deciphernow.com" \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --user root \
    endlessplanet/deciphernow &&
    docker container start --interactive $(cat ${PWD}/cidfile) &&
    docker container stop $(cat ${PWD}/cidfile) &&
    docker container rm $(cat ${PWD}/cidfile) &&
    rm -f $(cat ${PWD}/cidfile)