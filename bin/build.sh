#!/bin/sh

cd image &&
    docker image build --tag endlessplanet/deciphernow:$(git rev-parse --verify HEAD) .