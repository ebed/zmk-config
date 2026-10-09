#!/usr/bin/env bash
# scripts/setup-wezterm.sh — instala WezTerm y enlaza la config desde el repo.
# Solo relevante en macOS (en Linux/servidores remotos usa solo setup-tmux.sh).
# Idempotente — correr varias veces es seguro.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEZTERM_SRC="$REPO_DIR/wezterm"
WEZTERM_DEST="$HOME/.config/wezterm"

ok()   { printf '\033[0;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m⚠\033[0m  %s\n' "$*"; }
step() { printf '→ %s\n' "$*"; }

# ── 1. Solo corre en macOS ─────────────────────────────────────────────────────
if [[ "$(uname -s)" != "Darwin" ]]; then
    warn "setup-wezterm.sh es solo para macOS. En servidores remotos usa setup-tmux.sh."
    exit 0
fi

# ── 2. Instalar WezTerm si falta ──────────────────────────────────────────────
if ! command -v wezterm &>/dev/null; then
    step "WezTerm no encontrado — instalando via Homebrew..."
    if command -v brew &>/dev/null; then
        brew install --cask wezterm
        ok "WezTerm instalado"
    else
        warn "Homebrew no disponible. Instala WezTerm desde https://wezfurlong.org/wezterm/ y vuelve a correr este script."
        exit 1
    fi
else
    WEZTERM_VER=$(wezterm --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1 || echo "desconocida")
    ok "WezTerm $WEZTERM_VER"
fi

# ── 3. Crear directorio padre si no existe ────────────────────────────────────
mkdir -p "$HOME/.config"

# ── 4. Symlink ~/.config/wezterm → repo/wezterm ──────────────────────────────
if [ -L "$WEZTERM_DEST" ]; then
    current="$(readlink "$WEZTERM_DEST")"
    if [ "$current" = "$WEZTERM_SRC" ]; then
        ok "Symlink correcto: $WEZTERM_DEST → $WEZTERM_SRC"
    else
        step "Actualizando symlink (antes apuntaba a: $current)"
        ln -sf "$WEZTERM_SRC" "$WEZTERM_DEST"
        ok "Symlink actualizado"
    fi
elif [ -d "$WEZTERM_DEST" ]; then
    BACKUP="$WEZTERM_DEST.bak.$(date +%Y%m%d_%H%M%S)"
    step "Directorio existente encontrado — backup: $BACKUP"
    mv "$WEZTERM_DEST" "$BACKUP"
    ln -s "$WEZTERM_SRC" "$WEZTERM_DEST"
    ok "Symlink creado (backup en $BACKUP)"
else
    ln -s "$WEZTERM_SRC" "$WEZTERM_DEST"
    ok "Symlink creado: $WEZTERM_DEST → $WEZTERM_SRC"
fi

# ── 5. Permisos ejecutables ───────────────────────────────────────────────────
HOOKS_SRC="$WEZTERM_SRC/claude_hooks.sh"
if [ -f "$HOOKS_SRC" ]; then
    chmod +x "$HOOKS_SRC"
    ok "claude_hooks.sh ejecutable"
fi

# ── 6. Nota final ─────────────────────────────────────────────────────────────
echo ""
ok "Setup WezTerm completo."
echo "   Config: $WEZTERM_DEST → $WEZTERM_SRC"
echo "   Tabs:   CMD+T → nuevo tab con nombre (s:nombre para sesión tmux)"
echo "   Prefix: Ctrl+A (tmux local en tab 'local')"
echo ""
step "Si WezTerm está abierto, recarga la config con CMD+SHIFT+R o reinicia WezTerm."
