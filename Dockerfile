FROM jlesage/baseimage-gui:debian-13-v4.14.0

ENV APP_NAME="MediathekView" \
    DISPLAY=:0 \
    S6_KILL_GRACETIME=8000

ARG MV_VERSION="15.0.0"
LABEL MediathekVersion=$MV_VERSION

RUN APP_ICON_URL=https://avatars.githubusercontent.com/u/23032665 && \
    install_app_icon.sh "$APP_ICON_URL"

# Systempakete und Locale installieren
RUN add-pkg ffmpeg wget locales && \
    sed-patch 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN add-pkg ca-certificates libxtst6 && \
    update-ca-certificates


# MediathekView installieren
RUN wget --no-verbose -O /tmp/MediathekView.deb \
      https://download.mediathekview.de/stabil/MediathekView-latest-linux.deb && \
    apt-get install -y /tmp/MediathekView.deb && \
    rm -f /tmp/MediathekView.deb

VOLUME ["/config", "/output"]

COPY rootfs/ /
RUN chmod +x /startapp.sh
