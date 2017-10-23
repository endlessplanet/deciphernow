#!/bin/ssh

docker service create jdeathe/centos-ssh:2.3.0 ssh gen-key -f
docker secret create 