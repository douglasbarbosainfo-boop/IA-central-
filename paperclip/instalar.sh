#!/usr/bin/env bash
# Instala o Paperclip (https://github.com/paperclipai/paperclip) com o instalador oficial.
# Uso: bash paperclip/instalar.sh [opções do install.sh, ex.: --no-prompt --no-onboard]
set -euo pipefail

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

curl -fsSLO https://paperclip.ing/install.sh
curl -fsSLO https://paperclip.ing/install.sh.sha256

if command -v sha256sum >/dev/null 2>&1; then
  sha256sum -c install.sh.sha256
else
  shasum -a 256 -c install.sh.sha256
fi

bash install.sh "$@"
