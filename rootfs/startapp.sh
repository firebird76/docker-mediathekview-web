#!/bin/sh
export HOME=/config

#exec /usr/local/bin/MediathekView

# Schleife für den 6-Stunden-Rhythmus
while true; do
    echo "=================================================="
    echo "Starte automatischen MediathekView-Suchlauf: $(date)"
    echo "=================================================="
   
    # Sollte 'mediathekview' nicht gefunden werden, kannst du es durch 
    # den exakten Pfad (z.B. /usr/bin/mediathekview) ersetzen.
    /usr/local/bin/MediathekView -dq
    
    echo "--------------------------------------------------"
    echo "Downloads abgeschlossen. MediathekView beendet."
    echo "Nächster Suchlauf in 6 Stunden..."
    echo "=================================================="
    
    # 6 Stunden warten
    sleep 21600
done
