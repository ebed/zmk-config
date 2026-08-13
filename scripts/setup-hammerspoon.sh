#!/usr/bin/env bash
# Setup Hammerspoon config from this repo.
# Installs Hammerspoon if needed, then symlinks hammerspoon/init.lua → ~/.hammerspoon/init.lua.
# Safe to re-run — idempotent.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/hammerspoon/init.lua"
DEST_DIR="$HOME/.hammerspoon"
DEST="$DEST_DIR/init.lua"

# ── 1. Hammerspoon ────────────────────────────────────────────────────────────
if [ ! -d "/Applications/Hammerspoon.app" ]; then
    echo "→ Hammerspoon no encontrado."
    if command -v brew &>/dev/null; then
        echo "→ Instalando via Homebrew Cask..."
        brew install --cask hammerspoon
    else
        echo "⚠  Homebrew no disponible. Instala Hammerspoon manualmente:"
        echo "   https://github.com/Hammerspoon/hammerspoon/releases/latest"
        echo "   Luego vuelve a correr este script."
        exit 1
    fi
fi

# ── 2. ~/.hammerspoon/ ────────────────────────────────────────────────────────
mkdir -p "$DEST_DIR"

# ── 3. Symlink ────────────────────────────────────────────────────────────────
if [ -L "$DEST" ]; then
    current="$(readlink "$DEST")"
    if [ "$current" = "$SRC" ]; then
        echo "✓ Symlink ya existe y es correcto: $DEST → $SRC"
    else
        echo "→ Actualizando symlink: $DEST → $SRC  (antes: $current)"
        ln -sf "$SRC" "$DEST"
    fi
elif [ -f "$DEST" ]; then
    echo "→ Haciendo backup de init.lua existente → $DEST.bak"
    mv "$DEST" "$DEST.bak"
    ln -s "$SRC" "$DEST"
    echo "✓ Symlink creado: $DEST → $SRC"
else
    ln -s "$SRC" "$DEST"
    echo "✓ Symlink creado: $DEST → $SRC"
fi

# ── 4. Reload ─────────────────────────────────────────────────────────────────
if pgrep -x Hammerspoon &>/dev/null; then
    echo "→ Recargando Hammerspoon..."
    osascript -e 'tell application "Hammerspoon" to execute lua code "hs.reload()"' 2>/dev/null \
        && echo "✓ Config recargada." \
        || echo "⚠  Recarga automática falló — recarga manual: HS Console → hs.reload()"
else
    echo "→ Hammerspoon no está corriendo. Ábrelo y la config se cargará automáticamente."
    open -a Hammerspoon
fi

echo ""
echo "Listo. Shortcuts disponibles:"
echo "  ⌥⌘⇧W  → WezTerm"
echo "  ⌥⌘⇧S  → Slack"
echo "  ⌥⌘⇧Z  → Zoom"
echo "  ⌥⌘⇧C  → Chrome"
echo "  ⌥⌘⇧H  → Layer cheat sheet (toggle)"
