#!/bin/sh

(docker container exec --interactive --tty $(cat ${HOME}/docker/containers/gitlab-runner) gitlab-runner list > ${HOME}/runners.out.txt 2> ${HOME}/runners.err.txt || true) &&
    echo OUTPUT &&
    cat ${HOME}/runners.out.txt &&
    echo ERROR &&
    cat ${HOME}/runners.err.txt &&
    tail -n -1 ${HOME}/runners.err.txt | cut -f 1 -d " " | while read RUNNER
    do
        echo docker container exec --interactive --tty $(cat ${HOME}/docker/containers/gitlab-runner) gitlab-runner unregister --name ${RUNNER} &&
            docker container exec --interactive --tty $(cat ${HOME}/docker/containers/gitlab-runner) gitlab-runner unregister --name ${RUNNER}
    done &&
    ls -1 ${HOME}/docker/containers | while read FILE
    do
        docker container stop $(cat ${HOME}/docker/containers/${FILE}) &&
            docker container rm --volumes $(cat ${HOME}/docker/containers/${FILE}) &&
            rm -f ${HOME}/docker/containers/${FILE}
    done &&
    ls -1 ${HOME}/docker/networks | while read FILE
    do
        docker networks rm $(cat ${HOME}/docker/networks/${FILE}) &&
            rm -f ${HOME}/docker/networks/${FILE}
    done &&
    ls -1 ${HOME}/docker/volumes | while read FILE
    do
        docker volume rm $(cat ${HOME}/docker/volumes/${FILE}) &&
            rm -f ${HOME}/docker/volumes/${FILE}
    done