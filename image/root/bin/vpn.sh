#!/bin/sh

docker \
    container \
    run \
    --interactive \
    --tty \
    --cap-add=NET_ADMIN \
    --device /dev/net/tun \
    --name vpn \
    --volume fdbf84c9f9920309b66e93392bde49662a58338abd9128492db27fecb2537714:/vpn \
    --detach \
    dperson/openvpn-client \
        -v 'chimeravpn.363-283.io;emory.merryman;password'