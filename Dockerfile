FROM jlesage/baseimage-gui:debian-13-v4.10.7
ENV APP_NAME="MediathekView"
ENV DISPLAY=:0

# Generate and install favicons
RUN \
    APP_ICON_URL=https://avatars.githubusercontent.com/u/23032665 && \
    install_app_icon.sh "$APP_ICON_URL"

RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y ffmpeg wget mediathekview

RUN apt-get install -y apt-utils locales \
    && echo en_US.UTF-8 UTF-8 > /etc/locale.gen \
    && locale-gen    
    
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8    
    
    
# Install MediathekView
RUN wget --no-verbose https://download.mediathekview.de/stabil/MediathekView-latest-linux.deb && \
    apt-get install -y ./MediathekView-latest-linux.deb && \
    rm -rf ./MediathekView-latest-linux.deb

# Cleanup
RUN apt-get -y autoclean

ENV APP_NAME="Mediathekview" \
    S6_KILL_GRACETIME=8000

VOLUME ["/config"]
VOLUME ["/output"]    
    
# Copy startapp.sh and make it executable
COPY rootfs/ /
RUN chmod +x /startapp.sh
