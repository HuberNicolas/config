#!/usr/bin/env bash
# Symlinks the configs from this repo into $HOME. Existing files are moved to *.backup first.
# Usage: ./install.sh [--packages]   (--packages also runs `brew bundle` and installs VS Code extensions)
set -euo pipefail
cd "$(dirname "$0")"
REPO="$PWD"

grep -vE '^\s*(#|$)' links.txt | while IFS= read -r line; do
  src="$(awk '{print $1}' <<<"$line")"
  dst="$HOME/$(sed -E 's/^[^[:space:]]+[[:space:]]+//' <<<"$line")"
  if [ "$(readlink "$dst" 2>/dev/null)" = "$REPO/$src" ]; then
    echo "ok       $dst"; continue
  fi
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv "$dst" "$dst.backup"; echo "backup   $dst.backup"
  fi
  ln -s "$REPO/$src" "$dst"; echo "linked   $dst"
done

if [ "${1:-}" = "--packages" ]; then
  brew bundle --file=Brewfile
  xargs -n1 code --install-extension < vscode/extensions.txt
fi
