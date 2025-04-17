#!/bin/bash

# Configuración
LISTA_CANALES="canales.txt"      # Archivo con nombres de canales (uno por línea)
LISTA_IPTV="twitch_iptv.m3u"     # Archivo de salida IPTV (¡.m3u es más compatible!)
LOG_FILE="twitch_iptv.log"       # Registro de actividad
USER_AGENT="Mozilla/5.0"         # Evitar bloqueos
COOKIES=""                       # Opcional: cookies.txt para canales Sub-Only

# Función para generar la lista IPTV
generar_lista() {
    echo "#EXTM3U" > "$LISTA_IPTV"
    while IFS= read -r canal; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Procesando canal: $canal" >> "$LOG_FILE"
        URL_M3U8=$(yt-dlp -g "https://www.twitch.tv/$canal" --no-live-from-start --user-agent "$USER_AGENT" ${COOKIES:+--cookies "$COOKIES"} 2>> "$LOG_FILE")
        
        if [ -n "$URL_M3U8" ]; then
            echo "#EXTINF:-1 tvg-id=\"$canal\" tvg-name=\"$canal\" group-title=\"Twitch\",$canal" >> "$LISTA_IPTV"
            echo "$URL_M3U8" >> "$LISTA_IPTV"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ $canal: Añadido" >> "$LOG_FILE"
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ $canal: No está en vivo o no accesible" >> "$LOG_FILE"
        fi
    done < "$LISTA_CANALES"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Lista actualizada en $LISTA_IPTV" >> "$LOG_FILE"
}

# Ejecutar ahora y luego cada 10 minutos
generar_lista
while true; do
    sleep 600  # Esperar 10 minutos (600 segundos)
    generar_lista
done
