#!/usr/bin/env bash
set -euo pipefail

mkdir -p /tmp/xdg
chmod 700 /tmp/xdg

exec /usr/bin/supervisord -c /app/supervisord.conf
