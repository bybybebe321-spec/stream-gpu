FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:99 \
    XDG_RUNTIME_DIR=/tmp/xdg

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl wget gnupg unzip jq \
    xvfb x11-utils xdotool \
    pulseaudio alsa-utils libasound2 \
    supervisor \
    chromium-browser \
    ffmpeg \
    nginx \
    fontconfig fonts-dejavu-core \
    libnss3 libatk-bridge2.0-0 libgtk-3-0 libgbm1 libxss1 libxshmfence1 libdrm2 \
    && rm -rf /var/lib/apt/lists/*

# Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get update && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# MediaMTX
RUN set -eux; \
  mkdir -p /opt/mediamtx; \
  url=$(curl -fsSL https://api.github.com/repos/bluenviron/mediamtx/releases/latest \
    | jq -r '.assets[] | select(.name|test("linux_amd64.tar.gz$")) | .browser_download_url'); \
  curl -fsSL "$url" -o /tmp/mediamtx.tgz; \
  tar -xzf /tmp/mediamtx.tgz -C /opt/mediamtx; \
  rm /tmp/mediamtx.tgz; \
  chmod +x /opt/mediamtx/mediamtx

WORKDIR /app
COPY app/ /app/

RUN npm install

# безопасный chmod
RUN find /app -type f -name "*.sh" -exec chmod +x {} \;


EXPOSE 8080 8888 7070 1935

ENTRYPOINT ["/app/entrypoint.sh"]
