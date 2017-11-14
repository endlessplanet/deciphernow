#!/bin/sh
echo "${ID_RSA}" > ${HOME}/.ssh/id_rsa &&
    sed \
        -e "s#\${COUNTRY}#${COUNTRY}#" \
        -e "s#\${STATE}#${STATE}#" \
        -e "s#\${LOCALITY}#${LOCALITY}#" \
        -e "s#\${ORGANIZATION_NAME}#${ORGANIZATION_NAME}#" \
        -e "s#\${UNIT_NAME}#${UNIT_NAME}#" \
        -e "s#\${USER_NAME}#${USER_NAME}#" \
        -e "s#\${EMAIL_ADDRESS}#${EMAIL_ADDRESS}#" \
        /opt/docker/etc/certificate.txt | openssl \
        req \
        -x509 \
        -key ${HOME}/.ssh/id_rsa \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -out openvpn-user.crt &&
    head -n 26 /opt/docker/etc/openvpn-chimera-templateuser.ovpn > openvpn-chimera-user.ovpn &&
    cat openvpn-user.crt >> openvpn-chimera-user.ovpn &&
    head -n 31 /opt/docker/etc/openvpn-chimera-templateuser.ovpn | tail -n 2 >> openvpn-chimera-user.ovpn &&
    cat ${HOME}/.ssh/id_rsa >> openvpn-chimera-user.ovpn >> openvpn-chimera-user.ovpn &&
    tail -n 19 /opt/docker/etc/openvpn-chimera-templateuser.ovpn >> openvpn-chimera-user.ovpn &&
    (cat > up <<EOF
${LDAP_USERNAME}
${LDAP_PASSWORD}
EOF
    ) &&
    openvpn openvpn-chimera-user.ovpn