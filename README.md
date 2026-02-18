[![Docker](https://github.com/firebird76/docker-mediathekview-web/actions/workflows/docker-publish2.yml/badge.svg)](https://github.com/firebird76/docker-mediathekview-web/actions/workflows/docker-publish2.yml)

# docker-mediathekview
X11rdp Version of Mediathekview

## About
Using this container allows you to run Mediathekview as a service and control it via webbrowser like Firefox or Chrome.
The X11rdp feature is inherited from [https://github.com/jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui).

## Installation
### Manual

1. Download Dockerfile or clone the repository.
2. Run `docker build .` to create the docker image.
3. Wait until build process is finished.

### Pre-build
The Github repository is automatically build by Github Actions.
You can pull it from Docker Hub:
```
docker pull firebird76/docker-mediathekview-web:latest
```
Some older versions can also be acquired by using e.g.
```
docker pull firebird76/docker-mediathekview-web:1.1.0
```

## Running it
For additional configuration options, have a look at the [available environment-variables](https://github.com/jlesage/docker-baseimage-gui#environment-variables).
For basic usage, just use
```
docker run -it -p 127.0.0.1:5800:5800 --rm \
    -v $HOME/.mediathek3:/config:rw \
    -v <path to your media files>:/output:rw \
    firebird76/mediathekview-webinterface:latest
```

## Developing
Make your changes, then build new version:
`docker build --rm -t mymediathek -f Dockerfile .`

Run the container with some testing environment:
`docker run --name mymedia -p 127.0.0.1:5800:5800 --rm -it -e USER_ID=99 -e GROUP_ID=99 -e KEEP_APP_RUNNING=1 -v /tmp/mediathek_config:/config:rw -v /tmp/mediathek_downloads:/output:rw  mymediathek:latest`

attach to running container and debug:
`docker exec -it mymedia bash`
