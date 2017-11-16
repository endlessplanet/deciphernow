#!/bin/sh

git refresh &&
    git diff --exit-code &&
    git diff --cached --exit-code &&
    [ -z "$(git ls-files --other --exclude-standard --directory)" ] &&
    git fetch upstream "${MASTER_BRANCH}" &&
    git checkout --patch "upstream/${MASTER_BRANCH}" &&
    git commit