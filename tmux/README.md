# tmux — configuración

Config de tmux que acompaña al **Layer 9 (Tmux)** del teclado. Se versiona aquí para replicarla en otras máquinas.

## Arquitectura terminal: WezTerm local + tmux remoto

| Capa | Herramienta | Rol |
|------|-------------|-----|
| **Local (Mac)** | WezTerm | Tabs, splits, temas, fuentes, OSC — sin tmux |
| **Remoto (SSH)** | tmux | Sesiones persistentes, multiplexado, clipboard vía OSC 52 |

**Por qué no tmux local:** WezTerm ya provee tabs y splits nativos con GPU rendering, ligaduras y mejor integración macOS. Agregar tmux encima duplica el multiplexado sin beneficio.

**Por qué tmux remoto:** sesiones persistentes que sobreviven desconexiones, navegación sin ratón, estado compartido entre terminales. Indispensable en SSH.

**Clipboard bridge:** `set-clipboard on` + WezTerm `allow-passthrough on` → el texto copiado en tmux remoto llega al portapapeles del Mac vía OSC 52 sin plugins adicionales.

## Instalación

```bash
./scripts/setup-tmux.sh
```

| Paso | Qué hace |
|------|----------|
| 1 | Instala tmux si falta (Homebrew o apt) |
| 2 | Enlaza `~/.tmux.conf` → `tmux/tmux.conf` (respalda uno distinto como `~/.tmux.conf.bak`) |
| 3 | Recarga la config en el servidor tmux activo, si hay uno |

Idempotente. Como es un symlink, editar `~/.tmux.conf` edita el archivo del repo.

## Opciones

| Opción | Efecto |
|--------|--------|
| Prefix `Ctrl+A` | Reemplaza `Ctrl+B`. `Ctrl+A Ctrl+A` envía un `Ctrl+A` real |
| `mouse on` | Click, scroll y resize con el mouse |
| `base-index 1`, `pane-base-index 1` | Ventanas y panes desde 1; `renumber-windows on` evita huecos |
| `history-limit 50000` | 50 k líneas de scroll-back |
| `tmux-256color` + `Tc` override | True color (Neovim, Catppuccin) |
| `allow-passthrough on` | OSC 52 pasa de remoto al Mac vía WezTerm |
| `set-clipboard on` | tmux usa OSC 52 para copiar al portapapeles del host |
| `escape-time 0`, `focus-events on` | Sin delay en ESC; eventos de foco a la app |
| `mode-keys vi` | Copy-mode vi: `v` selecciona, `y` copia y sale |
| `update-environment SSH_AUTH_SOCK` | Refresca el socket del agente SSH en reconexión |
| Barra arriba: `sesión · hostname` | Identifica la máquina remota de un vistazo |
| Tema Catppuccin Mocha | Mismo tema que el entorno local |
| `-r` en resize | `H J K L` son repetibles sin re-pulsar el prefix |

## Atajos propios (prefix = `Ctrl+A`)

### Sesiones y ventanas

| Atajo | Acción | Tecla L9 (hold TAB +) |
|-------|--------|----------------------|
| `prefix` `,` | Renombrar ventana | `ESC`-pos |
| `prefix` `$` | Renombrar sesión | `REPT`-pos |
| `prefix` `p` / `n` | Ventana anterior / siguiente | `P`-pos / `B`-pos |
| `prefix` `1`–`5` | Ir a ventana 1–5 | `Q W F` / `A T` |
| `prefix` `c` | Nueva ventana | `C`-pos |
| `prefix` `d` | Detach sesión | `D`-pos |
| `prefix` `r` | Recargar `~/.tmux.conf` | `R`-pos |
| `prefix` `s` | Árbol de sesiones | `S`-pos |
| `prefix` `;` | Último pane | `G`-pos |
| `prefix` `C-l` | Última sesión | `V`-pos |

### Splits y panes

| Atajo | Acción | Tecla L9 |
|-------|--------|----------|
| `prefix` `\|` | Split horizontal (mismo dir) | `J`-pos fila 1 der |
| `prefix` `-` | Split vertical (mismo dir) | `L`-pos fila 1 der |
| `prefix` `h` / `j` / `k` / `l` | Ir al pane ← ↓ ↑ → | `N E` / `U`-pos / `I`-pos |
| `prefix` `z` | Zoom pane | `Z`-pos |
| `prefix` `x` | Cerrar pane | `X`-pos |
| `prefix` `&` | Cerrar ventana | `/`-pos fila 3 der |

### Resize (repetible con `-r`)

| Atajo | Acción | Tecla L9 |
|-------|--------|----------|
| `prefix` `H` | Resize ← 5 celdas | `K`-pos fila 3 der |
| `prefix` `J` | Resize ↓ 5 celdas | `H`-pos fila 3 der |
| `prefix` `K` | Resize ↑ 5 celdas | `,`-pos fila 3 der |
| `prefix` `L` | Resize → 5 celdas | `.`-pos fila 3 der |

### Copy-mode vi

| Atajo | Acción | Tecla L9 |
|-------|--------|----------|
| `prefix` `[` | Entrar copy-mode | `M`-pos home row der |
| `v` (en copy-mode) | Iniciar selección | — |
| `y` (en copy-mode) | Copiar y salir → clipboard (ver cadena abajo) | — |
| `prefix` `]` | Pegar | `O`-pos home row der |

### Cadena de clipboard (`y`)

`y` usa `copy-pipe-and-cancel` que dispara **en paralelo** el script helper y `set-clipboard on` (OSC 52 nativo de tmux). El script (`~/.local/bin/tmux-yank`, instalado por `setup-tmux.sh`) prueba en orden:

| Prioridad | Herramienta | Cuándo actúa |
|-----------|-------------|--------------|
| 1 | `pbcopy` | macOS (siempre disponible) |
| 2 | `xclip` | Linux con `$DISPLAY` (SSH + X forwarding) |
| 3 | `wl-copy` | Linux Wayland |
| 4 | OSC 52 manual (DCS passthrough) | Cualquier terminal que lo soporte sin pasar por tmux |
| 5 | `set-clipboard on` (tmux nativo) | Siempre activo como capa base; WezTerm, iTerm2, kitty |

Si ninguna herramienta nativa existe (SSH puro sin X), el flujo cae a OSC 52 — que en WezTerm llega al portapapeles del Mac automáticamente.

## Barra de estado

```
 sesión  hostname    1:zsh  ●2:nvim  3:ssh    │ 14:30  │ 09/10
```

- **Izquierda:** nombre de sesión (mauve) + hostname (blue) — esencial para identificar máquina en SSH
- **Centro:** ventanas; activa con `●`, inactiva atenuada, actividad en amarillo
- **Derecha:** hora (green) · fecha (teal)
- **Borde de pane activo:** azul; formato muestra el comando corriendo en el pane

## Notas

- `bind l` reemplaza `last-window` por defecto (`prefix l`); para volver a la ventana previa usa `p`/`n`.
- `%` y `"` quedan desvinculados a propósito: usa `|` y `-`.
- Si cambias el prefix o un bind aquí, actualiza Layer 9 (`config/corne.keymap`, `LAYOUTS.md`, `README.md`, `hammerspoon/init.lua`).
- Esta config no usa TPM ni plugins — todo nativo.

Mapa completo del layer: [LAYOUTS.md](../LAYOUTS.md#layer-9--tmux-hold-tab). El popup `⌥⌘⇧H` también lo muestra.
