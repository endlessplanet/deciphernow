#!/bin/sh

ssh-keygen -f /root/.ssh/id_rsa -P "" > /dev/null 2>&1 &&
    cat /root/.ssh/id_rsa.pub