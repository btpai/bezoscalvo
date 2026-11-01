#!/bin/bash
BASE="https://twitch-iptv.linx-mgb.workers.dev"

echo "#EXTM3U url-tvg=\"$BASE/epg.xml\"" > twitch_iptv.m3u
while IFS= read -r canal || [ -n "$canal" ]; do
  canal=$(echo "$canal" | tr -d '\r' | xargs | tr 'A-Z' 'a-z')
  [ -z "$canal" ] && continue
  echo "#EXTINF:-1 group-title=\"Twitch\" tvg-id=\"$canal\",$canal" >> twitch_iptv.m3u
  echo "$BASE/$canal.m3u8" >> twitch_iptv.m3u
done < canales.txt
