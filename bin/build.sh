#!/bin/sh

docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD} &&
    docker image build endlessplanet/deciphernow:$(git rev-parse --verify HEAD) &&
    docker image push endlessplanet/deciphernow:$(git rev-parse --verify HEAD)