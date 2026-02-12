#!/usr/bin/env bash
set -euo pipefail

exec ffmpeg \
  -f x11grab -video_size 1920x1080 -framerate 30 -i :99.0 \
  -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=48000 \
  -c:v libx264 -preset veryfast -tune zerolatency \
  -b:v 4500k -g 60 \
  -c:a aac -b:a 128k \
  -f flv rtmp://127.0.0.1:1935/live/stream
