#!/usr/bin/env bash
# Refreshes the generated lists (Homebrew packages, VS Code extensions) from this machine.
set -euo pipefail
cd "$(dirname "$0")"
brew bundle dump --file=Brewfile --force
code --list-extensions > vscode/extensions.txt
git status --short
