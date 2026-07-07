#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/claude"
TARGET="$HOME/.claude"

mkdir -p "$TARGET"

link() {
  local src="$REPO_DIR/$1"
  local dst="$TARGET/$1"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak"
    echo "backup: $dst → $dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "linked: $dst → $src"
}

link CLAUDE.md
link AGENT_STANDARDS.md
link agents
link commands
link skills
link templates
link statusline-command.sh

echo ""
echo "settings.json n'est PAS symlinké (le fichier global peut contenir des secrets locaux)."
if [ -f "$TARGET/settings.json" ]; then
  if diff -q "$REPO_DIR/settings.json" "$TARGET/settings.json" >/dev/null 2>&1; then
    echo "settings.json : identique au repo, rien à faire."
  else
    echo "settings.json : diffère du repo — merger à la main :"
    echo "  diff $REPO_DIR/settings.json $TARGET/settings.json"
  fi
else
  cp "$REPO_DIR/settings.json" "$TARGET/settings.json"
  echo "settings.json : copié (pas de fichier existant)."
fi
