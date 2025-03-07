# Pull base image.
#FROM jlesage/baseimage-gui:debian-12
#FROM jlesage/baseimage-gui:debian-12-v4
FROM jlesage/baseimage-gui:ubuntu-24.04-v4.7.1
ENV USER_ID=0 GROUP_ID=0 TERM=xterm
ENV DISPLAY_WIDTH=1920
ENV DISPLAY_HEIGHT=1080
ENV DARK_MODE=1
ENV MEDIATHEK_VERSION=14.2.0

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN apt-get update
RUN apt-get upgrade -y
# Build deps
RUN apt-get install -y apt-utils locales
RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen
RUN locale-gen

ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
# Run deps
RUN \
    apt-get install -y \
        wget \
        vlc \
        flvstreamer \
        ffmpeg \
        mediathekview

RUN wget --no-verbose https://download.mediathekview.de/stabil/MediathekView-latest-linux.deb && \
    apt-get install -y ./MediathekView-latest-linux.deb && \
    rm -rf ./MediathekView-latest-linux.deb
# Define software download URLs.

COPY src/startapp.sh /startapp.sh

# clear temporary build directory
#RUN rm /tmp/*

# Set environment variables.
ENV APP_NAME="Mediathekview" \
    S6_KILL_GRACETIME=8000

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/output"]

# Metadata.
LABEL \
      org.label-schema.name="mediathekview" \
      org.label-schema.description="Docker container for Mediathekview" \
      org.label-schema.version=$MEDIATHEK_VERSION \
      org.label-schema.vcs-url="https://github.com/conrad784/docker-mediathekview-webinterface" \
      org.label-schema.schema-version="1.0"
