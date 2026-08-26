FROM jlesage/baseimage-gui:debian-13-v4.11.3

ARG MV_VERSION="14.5.0"
LABEL MediathekVersion=$MV_VERSION

ENV JAVA_OPTS="-Djava.awt.headless=false -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
ENV APP_NAME="MediathekView" \
    DISPLAY=:0 \
    S6_KILL_GRACETIME=8000 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LANG=en_US.UTF-8

# 1. Icons generieren
RUN APP_ICON_URL=https://avatars.githubusercontent.com/u/23032665 && \
    install_app_icon.sh "$APP_ICON_URL"

# 2. System-Updates und Abhängigkeiten installieren (korrigiert!)
RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        ffmpeg \
        wget \
        apt-utils \
        locales && \
    apt-get install -y --no-install-recommends \
        xfonts-base \
        xfonts-75dpi \
        openjdk-21-jre-headless

# 3. Locales generieren
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# 4. MediathekView herunterladen und installieren (mit Fallback)
RUN echo "Building version: $MV_VERSION" && \
    wget --no-check-certificate -q --timeout=30 --tries=3 \
        https://download.mediathekview.de/stabil/MediathekView-latest-linux.deb -O /tmp/MediathekView.deb || \
    wget --no-check-certificate -q --timeout=30 --tries=3 \
        https://mediathekview.de/download/MediathekView-latest-linux.deb -O /tmp/MediathekView.deb && \
    apt-get install -y --fix-missing --allow-downgrades /tmp/MediathekView.deb && \
    rm -f /tmp/MediathekView.deb

# 5. Aufräumen
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 6. Java-Version prüfen
RUN java -version

# Volumes definieren
VOLUME ["/config"]
VOLUME ["/output"]

# Start-Skript kopieren und Rechte setzen
COPY rootfs/ /
RUN chmod +x /startapp.sh

CMD ["/startapp.sh"]
