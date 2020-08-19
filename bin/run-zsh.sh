#/bin/bash

docker run -ti \
    --user $(id -u $USER):$(id -g $USER) \
    -e "HOME=/home" \
    -e "TERM=xterm-256color" \
    -e "TZ=Europe/Rome" \
    -v /etc/passwd:/etc/passwd \
    -v /etc/group:/etc/group \
    -v $HOME:/home \
    hub.docker.com/olivomarco/dockerized-tools:0.1 \
    zsh
