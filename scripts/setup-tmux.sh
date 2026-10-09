#!/usr/bin/env bash
# Setup tmux config from this repo.
# Installs tmux if needed, then symlinks tmux/tmux.conf → ~/.tmux.conf.
# Safe to re-run — idempotent.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/tmux/tmux.conf"
DEST="$HOME/.tmux.conf"

# ── 1. tmux ───────────────────────────────────────────────────────────────────
if ! command -v tmux &>/dev/null; then
    echo "→ tmux no encontrado."
    if command -v brew &>/dev/null; then
        echo "→ Instalando via Homebrew..."
        brew install tmux
    elif command -v apt-get &>/dev/null; then
        echo "→ Instalando via apt..."
        sudo apt-get install -y tmux
    else
        echo "⚠  Instala tmux manualmente y vuelve a correr este script."
        exit 1
    fi
fi

# ── 2. Symlink ────────────────────────────────────────────────────────────────
if [ -L "$DEST" ]; then
    current="$(readlink "$DEST")"
    if [ "$current" = "$SRC" ]; then
        echo "✓ Symlink ya existe y es correcto: $DEST → $SRC"
    else
        echo "→ Actualizando symlink: $DEST → $SRC  (antes: $current)"
        ln -sf "$SRC" "$DEST"
    fi
elif [ -f "$DEST" ]; then
    if cmp -s "$DEST" "$SRC"; then
        echo "→ $DEST es idéntico al del repo, reemplazando por symlink"
    else
        echo "→ Haciendo backup de ~/.tmux.conf existente → $DEST.bak"
        mv "$DEST" "$DEST.bak"
    fi
    ln -sf "$SRC" "$DEST"
    echo "✓ Symlink creado: $DEST → $SRC"
else
    ln -s "$SRC" "$DEST"
    echo "✓ Symlink creado: $DEST → $SRC"
fi

# ── 3. Reload en sesiones activas ─────────────────────────────────────────────
if tmux list-sessions &>/dev/null; then
    tmux source-file "$DEST" && echo "✓ Config recargada en el servidor tmux activo."
else
    echo "→ No hay servidor tmux activo; la config se cargará en la próxima sesión."
fi

echo ""
echo "Listo. Prefix: Ctrl+A · splits: | y - · panes: h j k l · resize: H J K L · reload: prefix r"
