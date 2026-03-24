FROM n8nio/n8n:2.13.3
USER root
# 0) Restore apk into the image (n8n image is Alpine but apk may be removed)
RUN set -eux; \
  ARCH="$(uname -m)"; \
  case "$ARCH" in \
  x86_64) ALP_ARCH="x86_64" ;; \
  aarch64) ALP_ARCH="aarch64" ;; \
  armv7l) ALP_ARCH="armv7" ;; \
  *) echo "Unsupported arch: $ARCH"; exit 1 ;; \
  esac; \
  apk_pkg="$(wget -qO- "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ALP_ARCH}/" \
  | grep -o 'apk-tools-static-[0-9][^"]*\.apk' \
  | head -n 1)"; \
  wget -q "https://dl-cdn.alpinelinux.org/alpine/latest-stable/main/${ALP_ARCH}/${apk_pkg}"; \
  tar -xzf "${apk_pkg}" -C /; \
  ln -sf /sbin/apk.static /sbin/apk; \
  rm -f "${apk_pkg}"; \
  /sbin/apk --version

# install ffmeg
RUN apk update && apk add --no-cache ffmpeg fontconfig ttf-freefont

COPY fonts /usr/share/fonts/custom

RUN fc-cache -f -v

USER node