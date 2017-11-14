
dnf update --assumeyes &&
    dnf install --assumeyes procps-ng &&
    dnf install --assumeyes curl &&
    dnf install --assumeyes salt-minion &&
    dnf clean all &&
    /usr/bin/salt-minion