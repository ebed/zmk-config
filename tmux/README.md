# tmux — configuración

Config de tmux que acompaña al **Layer 9 (Tmux)** del teclado. Se versiona aquí para replicarla en otras máquinas.

## Instalación

```bash
./scripts/setup-tmux.sh
```

| Paso | Qué hace |
|------|----------|
| 1 | Instala tmux si falta (Homebrew o apt) |
| 2 | Enlaza `~/.tmux.conf` → `tmux/tmux.conf` (respalda uno distinto como `~/.tmux.conf.bak`) |
| 3 | Recarga la config en el servidor tmux activo, si hay uno |

Idempotente. Como es un symlink, editar `~/.tmux.conf` edita el archivo del repo: commitea los cambios.

## Opciones

| Opción | Efecto |
|--------|--------|
| Prefix `Ctrl+A` | Reemplaza `Ctrl+B`. `Ctrl+A Ctrl+A` envía un `Ctrl+A` real a la app |
| `mouse on` | Click, scroll y resize con el mouse |
| `base-index 1`, `pane-base-index 1` | Ventanas y panes desde 1; `renumber-windows on` evita huecos |
| `tmux-256color` + RGB | True color (neovim) |
| `escape-time 0`, `focus-events on` | Sin delay en ESC |
| `mode-keys vi` | Copy-mode con teclas vi (`v` selecciona, `y` copia y sale) |
| Barra de estado arriba | Tema oscuro; sesión a la izquierda, hora y fecha a la derecha |

## Atajos propios (prefix = `Ctrl+A`)

| Atajo | Acción | Tecla en Layer 9 (hold `TAB` +) |
|-------|--------|---------------------------------|
| `prefix` `\|` | Split lado a lado, mismo directorio | `U` |
| `prefix` `-` | Split apilado, mismo directorio | `Y` |
| `prefix` `h j k l` | Ir al pane ← ↓ ↑ → | `H` `J` `K` `L` |
| `prefix` `H J K L` | Redimensionar 5 celdas ← ↓ ↑ → | `E` `I` `O` `'` |
| `prefix` `r` | Recargar `~/.tmux.conf` | `R` |
| `prefix` `s` | Árbol de sesiones y ventanas | `S` |
| `prefix` `Ctrl+L` | Última sesión | `V` |

## Atajos de tmux por defecto que también usa el layer

| Atajo | Acción | Tecla en Layer 9 |
|-------|--------|------------------|
| `prefix` `c` / `n` / `p` | Nueva / siguiente / anterior ventana | `C` / `N` / `P` |
| `prefix` `1`-`5` | Ir a la ventana N | `Q` `W` `F` `A` `T` |
| `prefix` `z` | Zoom del pane | `Z` |
| `prefix` `x` / `&` | Cerrar pane / ventana | `X` / tecla `,` |
| `prefix` `d` | Detach | `D` |
| `prefix` `;` | Último pane | `G` |
| `prefix` `,` / `$` | Renombrar ventana / sesión | `ESC`-pos. / `REPT`-pos. |
| `prefix` `[` / `]` | Copy-mode / pegar | `B` / `M` |

Mapa completo del layer: [LAYOUTS.md](../LAYOUTS.md#layer-9--tmux-hold-tab). El popup `⌥⌘⇧H` de Hammerspoon también lo muestra.

## Notas

- `bind l` reemplaza el `last-window` por defecto de tmux (`prefix l`); para volver a la ventana previa usa `prefix p`/`n` o `prefix w`.
- `%` y `"` quedan desvinculados a propósito: usa `|` y `-`.
- Si cambias el prefix o un bind aquí, actualiza el Layer 9 (`config/corne.keymap`, `LAYOUTS.md`, `README.md` y `hammerspoon/init.lua`).
- TPM (`~/.tmux/plugins/tpm`) puede estar instalado, pero esta config no declara plugins.
