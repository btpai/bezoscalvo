#!/bin/bash
BASE="https://twitch-iptv.tunombre.workers.dev"

echo "#EXTM3U" > twitch_iptv.m3u
while IFS= read -r canal || [ -n "$canal" ]; do
  canal=$(echo "$canal" | tr -d '\r' | xargs)
  [ -z "$canal" ] && continue
  echo "#EXTINF:-1 group-title=\"Twitch\" tvg-id=\"$canal\",$canal" >> twitch_iptv.m3u
  echo "$BASE/$canal.m3u8" >> twitch_iptv.m3u
done < canales.txt
