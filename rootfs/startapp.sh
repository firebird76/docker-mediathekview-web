#!/bin/sh
export HOME=/config

export JAVA_OPTS="-Djava.awt.headless=false -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
exec java $JAVA_OPTS -jar /opt/MediathekView/MediathekView.jar
