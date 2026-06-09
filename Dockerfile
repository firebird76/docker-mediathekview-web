FROM jlesage/baseimage-gui:debian-13-v4.11.3
ENV APP_NAME="MediathekView"
ENV DISPLAY=:0
ARG MV_VERSION="14.5.0"
LABEL MediathekVersion=$MV_VERSION

# Generate and install favicons
RUN \
    APP_ICON_URL=https://avatars.githubusercontent.com/u/23032665 && \
    install_app_icon.sh "$APP_ICON_URL"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget dpkg ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download MediathekView
RUN echo "Building version: $MV_VERSION" && \
    wget --no-verbose --no-check-certificate -O /tmp/MediathekView.deb \
        "https://download.mediathekview.de/stabil/MediathekView-${MV_VERSION}-linux.deb"

# Install MediathekView first to get all files
RUN apt-get install -y /tmp/MediathekView.deb && \
    rm /tmp/MediathekView.deb

# Find and copy the icon (multiple possible locations)
RUN if [ -f /opt/MediathekView/icon.png ]; then \
        cp /opt/MediathekView/icon.png /opt/MediathekView/icon.png.bak; \
    elif [ -f /usr/share/pixmaps/mediathekview.xpm ]; then \
        cp /usr/share/pixmaps/mediathekview.xpm /opt/MediathekView/icon.png; \
    elif [ -f /opt/MediathekView/lib/app/MediathekView.jar ]; then \
        # Extract icon from JAR file (common location for Java apps)
        mkdir -p /tmp/icon_extract && \
        cd /tmp/icon_extract && \
        unzip -q /opt/MediathekView/lib/app/MediathekView.jar icon*.png icon*.ico 2>/dev/null || true && \
        if [ -f icon.png ]; then \
            cp icon.png /opt/MediathekView/; \
        elif ls icon*.png >/dev/null 2>&1; then \
            cp icon*.png /opt/MediathekView/; \
        fi && \
        rm -rf /tmp/icon_extract; \
    fi

# Locale configuration
RUN apt-get update && \
    apt-get install -y apt-utils locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LANG=en_US.UTF-8

ENV APP_NAME="MediathekView" \
    S6_KILL_GRACETIME=2000

# Volumes for configuration and output
VOLUME ["/config", "/output"]

# Copy start script and make it executable
COPY rootfs/startapp.sh /startapp.sh
RUN chmod +x /startapp.sh
