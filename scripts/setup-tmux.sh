#!/usr/bin/env bash
# scripts/setup-tmux.sh — instala tmux >= 3.3, terminfo tmux-256color y enlaza la config.
# Rol: esta config es el motor de sesiones para máquinas REMOTAS (SSH). Local: WezTerm nativo.
# Idempotente — correr varias veces es seguro.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$REPO_DIR/tmux/tmux.conf"
DEST="$HOME/.tmux.conf"
MIN_MAJOR=3; MIN_MINOR=3   # allow-passthrough (OSC 52 clipboard) requiere >= 3.3

# ── helpers ───────────────────────────────────────────────────────────────────
ok()   { printf '\033[0;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m⚠\033[0m  %s\n' "$*"; }
step() { printf '→ %s\n' "$*"; }

# ── 1. Instalar tmux si falta ─────────────────────────────────────────────────
if ! command -v tmux &>/dev/null; then
    step "tmux no encontrado — instalando..."
    if command -v brew &>/dev/null; then
        brew install tmux
    elif command -v apt-get &>/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y tmux
    else
        warn "Instala tmux >= $MIN_MAJOR.$MIN_MINOR manualmente y vuelve a correr este script."
        exit 1
    fi
fi

# ── 2. Verificar versión (>= 3.3 para allow-passthrough / OSC 52) ─────────────
TMUX_VER=$(tmux -V | grep -oE '[0-9]+\.[0-9]+' | head -1)
TMUX_MAJOR=${TMUX_VER%%.*}
TMUX_MINOR=${TMUX_VER##*.}

version_ok() {
    [ "$TMUX_MAJOR" -gt "$MIN_MAJOR" ] || \
    { [ "$TMUX_MAJOR" -eq "$MIN_MAJOR" ] && [ "$TMUX_MINOR" -ge "$MIN_MINOR" ]; }
}

if ! version_ok; then
    warn "tmux $TMUX_VER detectado — se requiere >= $MIN_MAJOR.$MIN_MINOR para clipboard OSC 52."
    if command -v brew &>/dev/null; then
        step "Actualizando via Homebrew..."
        brew upgrade tmux 2>/dev/null || brew install tmux
        TMUX_VER=$(tmux -V | grep -oE '[0-9]+\.[0-9]+' | head -1)
        TMUX_MAJOR=${TMUX_VER%%.*}; TMUX_MINOR=${TMUX_VER##*.}
        version_ok && ok "tmux $TMUX_VER" || warn "Actualización falló — instala tmux >= $MIN_MAJOR.$MIN_MINOR manualmente."
    elif command -v apt-get &>/dev/null; then
        warn "El tmux del sistema es antiguo. Para instalar una versión reciente:"
        echo "  Ubuntu/Debian:  sudo snap install tmux --classic"
        echo "  o compilar:     https://github.com/tmux/tmux/releases"
        echo "  La config cargará pero clipboard bridge (OSC 52) puede no funcionar."
    fi
else
    ok "tmux $TMUX_VER (>= $MIN_MAJOR.$MIN_MINOR)"
fi

# ── 3. terminfo tmux-256color (true color: Neovim, Catppuccin) ────────────────
if ! infocmp tmux-256color &>/dev/null 2>&1; then
    step "terminfo tmux-256color no encontrado — instalando..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get install -y ncurses-term
    elif command -v brew &>/dev/null; then
        NCURSES_PREFIX="$(brew --prefix ncurses 2>/dev/null || true)"
        if [ -z "$NCURSES_PREFIX" ]; then
            brew install ncurses
            NCURSES_PREFIX="$(brew --prefix ncurses)"
        fi
        TI_SRC="$NCURSES_PREFIX/share/terminfo/t/tmux-256color"
        if [ -f "$TI_SRC" ]; then
            mkdir -p "$HOME/.terminfo/t"
            cp -n "$TI_SRC" "$HOME/.terminfo/t/" && step "terminfo copiado desde ncurses"
        else
            warn "No se encontró tmux-256color en Homebrew ncurses; fallback a xterm-256color."
        fi
    fi

    if infocmp tmux-256color &>/dev/null 2>&1; then
        ok "terminfo tmux-256color"
    else
        warn "tmux-256color aún no disponible — el true color puede no funcionar en este host."
    fi
else
    ok "terminfo tmux-256color"
fi

# ── 4. Clipboard helper tmux-yank ────────────────────────────────────────────
YANK_SRC="$REPO_DIR/tmux/yank.sh"
YANK_DEST="$HOME/.local/bin/tmux-yank"
mkdir -p "$HOME/.local/bin"
chmod +x "$YANK_SRC"   # siempre: sin bit de ejecución tmux falla en silencio (bind lleva "2>/dev/null; true")

if [ -L "$YANK_DEST" ] && [ "$(readlink "$YANK_DEST")" = "$YANK_SRC" ]; then
    ok "tmux-yank symlink correcto"
else
    ln -sf "$YANK_SRC" "$YANK_DEST"
    ok "tmux-yank instalado: $YANK_DEST"
fi

# xclip en Linux para clipboard X11 (silencioso si no hay apt o ya está instalado)
if command -v apt-get &>/dev/null && ! command -v xclip &>/dev/null; then
    step "Instalando xclip (clipboard X11)..."
    sudo apt-get install -y xclip 2>/dev/null && ok "xclip instalado" || warn "xclip no disponible — X11 clipboard no funcionará (OSC 52 sigue activo)"
fi

# ── 5. Symlink ~/.tmux.conf → repo ───────────────────────────────────────────
if [ -L "$DEST" ]; then
    current="$(readlink "$DEST")"
    if [ "$current" = "$SRC" ]; then
        ok "Symlink correcto: $DEST → $SRC"
    else
        step "Actualizando symlink (antes: $current)"
        ln -sf "$SRC" "$DEST"
        ok "Symlink actualizado"
    fi
elif [ -f "$DEST" ]; then
    if cmp -s "$DEST" "$SRC"; then
        step "~/.tmux.conf idéntico al del repo — reemplazando por symlink"
    else
        step "Backup: $DEST → $DEST.bak"
        mv "$DEST" "$DEST.bak"
    fi
    ln -sf "$SRC" "$DEST"
    ok "Symlink creado: $DEST → $SRC"
else
    ln -s "$SRC" "$DEST"
    ok "Symlink creado: $DEST → $SRC"
fi

# ── 6. Reload en sesiones activas ─────────────────────────────────────────────
if tmux list-sessions &>/dev/null 2>&1; then
    tmux source-file "$DEST" && ok "Config recargada en el servidor tmux activo."
else
    step "No hay servidor tmux activo — la config se cargará en la próxima sesión."
fi

# ── 7. Nota de clipboard en macOS (WezTerm) ──────────────────────────────────
if [[ "$(uname -s)" == "Darwin" ]]; then
    echo ""
    step "WezTerm (local): OSC 52 está habilitado por defecto — nada extra que configurar."
    step "Si el clipboard bridge no funciona desde remoto, verifica en wezterm.lua:"
    echo "     config.enable_wayland = false  -- no aplica en macOS, pero sí en Linux"
    echo "     -- OSC 52 requiere WezTerm >= 20220624"
fi

echo ""
ok "Setup tmux completo."
echo "   Prefix: Ctrl+A  ·  splits: | / -  ·  panes: h j k l  ·  resize: H J K L  ·  reload: prefix r"

# ── macOS: recordar correr setup-wezterm.sh ───────────────────────────────────
if [[ "$(uname -s)" == "Darwin" ]]; then
    echo ""
    step "En macOS también puedes instalar la config de WezTerm:"
    echo "   bash $(dirname "${BASH_SOURCE[0]}")/setup-wezterm.sh"
fi
