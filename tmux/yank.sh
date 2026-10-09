#!/usr/bin/env bash
# tmux-yank: clipboard helper para copy-mode.
# Prioridad: pbcopy (macOS) → xclip (X11) → wl-copy (Wayland) → OSC 52 manual.
# Si ninguna herramienta nativa existe, tmux maneja OSC 52 vía set-clipboard on.
# No devuelve error — el bind en tmux.conf usa "; true" para no interrumpir.

buf=$(cat)
[ -z "$buf" ] && exit 0

# 1. macOS
if command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "$buf" | pbcopy
    exit 0
fi

# 2. Linux X11
if [ -n "${DISPLAY-}" ] && command -v xclip >/dev/null 2>&1; then
    printf '%s' "$buf" | xclip -selection clipboard
    exit 0
fi

# 3. Linux Wayland
if [ -n "${WAYLAND_DISPLAY-}" ] && command -v wl-copy >/dev/null 2>&1; then
    printf '%s' "$buf" | wl-copy
    exit 0
fi

# 4. OSC 52 manual (fallback cuando set-clipboard on no llega por algún motivo)
# Necesario si el terminal externo soporta OSC 52 pero tmux no lo pasa automáticamente.
b64=$(printf '%s' "$buf" | base64 | tr -d '\n')
if [ -n "${TMUX-}" ]; then
    # Dentro de tmux: envolver en DCS passthrough para que llegue al terminal externo
    printf '\033Ptmux;\033\033]52;c;%s\007\033\\' "$b64"
else
    printf '\033]52;c;%s\007' "$b64"
fi
