# Dockerized tools

This project creates a docker image containing various utilities that can be used in many different situations:

- using a consistent environment for CI runners, such as those offered by [Gitlab](https://gitlab.com)
- sharing a common shell environment between developers on a project, without having to resort to the same set of VMs

The commands provided in the docker image are several utilities to manage Kubernetes clusters, several cloud provider CLIs, and some common Linux utils.
One can always add more to the [Dockerfile](/Dockerfile) and rebuild the image.

## Creating the image

On a machine with Docker installed:

```bash
docker build . -t hub.docker.com/olivomarco/dockerized-tools:tag
```

where `tag` is the tag name to use (e.g. `0.1`)

## Using the image

On a machine with Docker installed, run this command in order to run zsh shell

```bash
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
```

or to run bash shell:

```bash
docker run -ti \
    --user $(id -u $USER):$(id -g $USER) \
    -e "HOME=/home" \
    -e "TZ=Europe/Rome" \
    -v /etc/passwd:/etc/passwd \
    -v /etc/group:/etc/group \
    -v $HOME:/home \
    hub.docker.com/olivomarco/dockerized-tools:0.1 \
    bash
```

With the above commands the local home directory of the user running the command will be mounted under `/home`; therefore, all his/her scripts and configuration files (like kubeconfig files, for instance) will be passed to the dockerized environment, and will be therefore visible and accessible inside the container.
