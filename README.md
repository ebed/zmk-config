# Corne Keyboard — ZMK Config

Configuración personalizada para teclado Corne (CRKBD) split 42 teclas usando [ZMK Firmware](https://zmk.dev/) v0.3.0.

---

## Quick Reference

> Layouts completos (ASCII art de ambos lados): **[LAYOUTS.md](LAYOUTS.md)**

| Layer | Activación | Función principal |
|-------|-----------|-------------------|
| **0 Base** | siempre activa | Colemak-DH + HRM en home row |
| **1 Sym** | hold `MO1` | Números con hold-tap, símbolos directos |
| **2 Nav** | hold `MO2` | Mouse, flechas, word-jump, selección |
| **3 Sys** | combo `SPC+MO2` | BT, media, RGB, brillo, lock |
| **4 Fn** | hold `BSP/L4` | F1–F12 |
| **5 Mac** | hold `RET/L5` | macOS, Rectangle, tmux, undo/redo, browser, display |
| **6 Lang** | hold `CW/L6` | Español: ´ ~ ¨ ¿ ¡ |
| **7 Apps** | hold `MO7` | Zoom, Slack, WezTerm, Claude Desktop |

**Thumbs y teclas especiales (Layer 0):**

| Posición | Tecla | Tap | Hold |
|----------|-------|-----|------|
| Bot-izq (pinky row) | `CW/⌘` | CapsWord | ⌘ GUI |
| Izq externo (thumb) | `CW/L6` | CapsWord | Layer 6 (Lang) |
| Izq medio (thumb) | `MO7` | — | Layer 7 (Apps) |
| Izq interno (thumb) | `SPC` | Space | — |
| Der interno (thumb) | `RET/L5` | ↵ RET | Layer 5 (Mac) |
| Der medio (thumb) | `MO2` | — | Layer 2 (Nav) |
| Der externo (thumb) | `MO1` | — | Layer 1 (Sym) |
| Top-der (pinky row) | `BSP/L4` | ⌫ BSPC | Layer 4 (Fn) |
| Bot-der (pinky row) | `REPT` | repite último key | — |

---

## Hardware

| Componente | Detalle |
|---|---|
| Teclado | Corne (CRKBD) — 3×6 + 3 thumbs por lado |
| Controlador | nice!nano v2 (nRF52840) |
| Display | OLED 128×32 con [zmk-nice-oled](https://github.com/mctechnology17/zmk-nice-oled) |
| RGB | Underglow WS2812 — 27 LEDs |
| Conectividad | Bluetooth 5.0 (5 perfiles) + USB |

---

## Acceso a Capas

```
Base (Layer 0) — siempre activa
  └─ hold MO1 (pulgar der externo) → Sym (Layer 1)
       └─ hold MO2 → TOG1 (bloquea Layer 1 — numpad mode)
       └─ tap inner right → MO3 → Sys (Layer 3)   [alternativa a combo]
  └─ hold MO2 (pulgar der medio) → Nav (Layer 2)
       └─ tap inner right → MO4 → Fn (Layer 4)
  └─ combo SPC+MO2 (left inner + right middle) → Sys (Layer 3)   ← acceso directo
  └─ hold BSP/L4 (top-der, BSPC) → Fn (Layer 4)                  ← acceso directo
  └─ hold MO7 (pulgar izq medio) → Apps (Layer 7)                  ← single key
  └─ hold RET/L5 (pulgar der interno) → Mac (Layer 5)              ← single key
  └─ hold CW/L6 (pulgar izq externo) → Lang (Layer 6)              ← single key
  └─ tap CW/⌘ (bot-izq) → CapsWord / hold → ⌘ GUI
```

---

## Layer 0 — Base (Colemak-DH + Home Row Mods)

### Home Row Mods (HRM)

Tap = letra / Hold = modificador. Orden GACS (fuera → dentro):

| Dedo | Tecla | Tap | Hold |
|------|-------|-----|------|
| Pinky izq | `A` | `a` | `LGUI` (Cmd) |
| Anular izq | `R` | `r` | `LALT` |
| Medio izq | `S` | `s` | `LCTRL` |
| Índice izq | `T` | `t` | `LSHFT` |
| Índice der | `N` | `n` | `RSHFT` |
| Medio der | `E` | `e` | `RCTRL` |
| Anular der | `I` | `i` | `RALT` |
| Pinky der | `O` | `o` | `RGUI` |

**Timings:** `tapping-term=400ms` · `quick-tap=175ms` · `require-prior-idle=200ms` · flavor `balanced` · positional HRM (hold solo con mano contraria)

### `CW/L6` — Outer left thumb (CapsWord / Lang layer)

| Input | Output |
|-------|--------|
| Tap | CapsWord (letras en mayúscula hasta espacio o símbolo) |
| Hold | Layer 6 (Lang/Español) — libera para volver a Base |

> ⌃ Ctrl y ⇧ Shift vienen del HRM en `S` y `T` respectivamente — no tienen tap en thumbs.

### `MO7` — Middle left thumb (Apps layer — hold only)

| Input | Output |
|-------|--------|
| Hold | Layer 7 (Apps — Zoom, Slack, WezTerm, Claude) |

### `RET/L5` — Inner right thumb (Return / Mac layer)

| Input | Output |
|-------|--------|
| Tap | ↵ Return |
| Hold | Layer 5 (Mac shortcuts / Rectangle / tmux) |

### `BSP/L4` — Top-right (BSPC / Fn layer)

| Input | Output |
|-------|--------|
| Tap | ⌫ Backspace |
| Hold | Layer 4 (Fn — F1–F12) |

### `CW/⌘` — Bottom-left (CapsWord / GUI)

| Input | Output |
|-------|--------|
| Tap | CapsWord (letras en mayúscula hasta espacio o símbolo) |
| Hold | ⌘ GUI (Cmd) |

### `&gresc` — ESC inteligente

| Input | Output |
|-------|--------|
| Tap | `ESC` |
| Shift + Tap | `~` (tilde) |

### Combo ESC

**`J + L`** simultáneos → `ESC` (timeout 50ms). Alternativa sin mover manos del home row.

### Caps Word (`CPSW`)

Activa modo ALL_CAPS. Las letras salen en mayúscula y `_` pasa sin desactivar. Se apaga solo al presionar espacio u otro símbolo.

---

## Layer 1 — Sym (hold MO1)

Dos rutas para acceder a símbolos:
- **Hold-tap en número**: tap = dígito / hold = símbolo Shift+número (`1/!`, `2/@`, ...)
- **Home row**: símbolos directos sin Shift para acceso ergonómico rápido

`REPT` (`&key_repeat`) — repite el último key presionado en cualquier layer. Acceso: `MO1 + ESC/~`.

`TOG1` (`&tog 1`) — bloquea Layer 1 sin tener que mantener el pulgar. Acceso: `hold MO1 + tap outer-right thumb`. Para salir: tap `TOG1` nuevamente.

### Hold-tap en números (`num_sym`)

| Tap | Hold | | Tap | Hold |
|-----|------|-|-----|------|
| `1` | `!` | | `6` | `^` |
| `2` | `@` | | `7` | `&` |
| `3` | `#` | | `8` | `*` |
| `4` | `$` | | `9` | `(` |
| `5` | `%` | | `0` | `)` |

`tapping-term=200ms` · `quick-tap=175ms` · flavor `tap-preferred`

### Home row — símbolos directos (ruta ergonómica)

| Símbolo | Tecla | | Símbolo | Tecla |
|---------|-------|-|---------|-------|
| `!` | A | | `&` | Z |
| `@` | R | | `*` | X |
| `#` | S | | `(` | C |
| `$` | T | | `)` | D |
| `%` | G | | `_` | V |
| `-` | M (der) | | `[` | K (der) |
| `=` | N (der) | | `]` | H (der) |
| `^` | E (der) | | `{` | , (der) |
| `\|` | I (der) | | `}` | . (der) |
| `\` | O (der) | | `+` | / (der) |

### Sticky Shift (`SK`) — posición CTRL en Layer 1 (abajo del TAB)

| Input | Resultado |
|-------|-----------|
| Tap | Shift activo para el próximo char, luego off |
| Doble tap | Sticky — shift hasta la próxima tecla modificadora |
| Triple tap | Lock — equivalente a CapsLock real |

Útil cuando `require-prior-idle` del HRM bloquea activación por haber tipeado recientemente.

---

## Layer 2 — Nav (hold MO2)

Mouse en la mano izquierda — click, scroll y movimiento. Flechas + navegación en la derecha.

Velocidad del mouse: `1500` (default ZMK: 600). Scroll: `20`.

| Key | Acción |
|-----|--------|
| `WJ←` / `WJ→` | Word jump — `⌥←/→` (saltar palabra) |
| `←` `↓` `↑` `→` | Flechas normales |
| `⇧HOME` / `⇧END` | Selección al inicio / fin de línea |
| `SEL↑` `SEL←` `SEL↓` `SEL→` | Selección de texto — `Shift+↑/←/↓/→` |
| `HOME` / `END` | Inicio / fin de línea |
| `PGUP` / `PGDN` | Página arriba / abajo |

Layer 7 (Apps): hold `CTL/L7` (pulgar izq-medio) desde cualquier layer — single key, sin combo. El lado derecho hereda los keybindings de Nav, por lo que las flechas y el mouse siguen funcionando.

---

## Layer 3 — Sys (combo SPC+MO2)

| Key | Acción |
|-----|--------|
| `BTCLR` | Borra emparejamiento del perfil activo |
| `BT0–BT5` | Selecciona perfil Bluetooth |
| `BLE/USB` | Cambia output activo |
| `PRV/PLAY/NXT` | Media: pista anterior / play-pause / siguiente |
| `VOL-/VOL+` | Volumen |
| `BRI-/BRI+` | Brillo de pantalla |
| `MUTE` | Silenciar |
| `LCK` | Lock screen macOS (`⌘+Ctrl+Q`) |
| `SOFF` | Soft-off (apagado profundo, requiere reset para despertar) |
| `BOOT` | Entra en modo bootloader para flashear firmware |

---

## Layer 4 — Fn (hold BSP/L4)

F1–F12 en la fila superior.

---

## Layer 5 — Mac (hold RET/L5)

Activación: hold pulgar derecho externo (`RET/L5`).

> **DSK1-5 y MW←/→** requieren activar los atajos correspondientes en **Ajustes del sistema → Teclado → Atajos → Mission Control**.

### Rectangle — Window Management (lado derecho, fila superior)

Requiere [Rectangle](https://rectangleapp.com/) instalado con atajos `⌥⌘`.

| Tecla | Shortcut | Acción |
|-------|----------|--------|
| `J` | `⌥⌘←` | Snap mitad izquierda |
| `L` | `⌥⌘→` | Snap mitad derecha |
| `U` | `⌥⌘↑` | Snap mitad superior |
| `Y` | `⌥⌘↓` | Snap mitad inferior |
| `;` | `⌥⌘F` | Maximizar |
| `BSPC` | `⌥⌘⌫` | Restaurar tamaño anterior |
| `N` | `⌥⌘C` | Centrar ventana |

### Shortcuts macOS (lado izquierdo)

| Tecla | Shortcut | Acción |
|-------|----------|--------|
| `ESC/~` | `Ctrl+1` | Ir a escritorio 1 |
| `Q` | `Ctrl+2` | Ir a escritorio 2 |
| `W` | `Ctrl+3` | Ir a escritorio 3 |
| `F` | `Ctrl+4` | Ir a escritorio 4 |
| `P` | `Ctrl+5` | Ir a escritorio 5 |
| `B` | `⌘⌥H` | Hide others (ocultar otras apps) |
| `TAB` | `⌘⌥Esc` | Force Quit |
| `A` | `⌘⌃⇧4` | Screenshot área → portapapeles |
| `R` | `⌘⇧4` | Screenshot área → archivo |
| `S` | `⌘Z` | Undo |
| `T` | `⌘⇧Z` | Redo |
| `G` | `Ctrl+↑` | Mission Control |
| `Z` | `Ctrl+←` | Escritorio anterior |
| `X` | `Ctrl+→` | Escritorio siguiente |
| `C` | `Ctrl+↓` | App Exposé (ventanas de la app activa) |
| `D` | `Ctrl+⇧←` | Mover ventana al escritorio anterior |
| `V` | `Ctrl+⇧→` | Mover ventana al escritorio siguiente |

> **Nota:** Las tildes y caracteres especiales (´ ~ ¨ ¿ ¡) están en **Layer 6 (Lang)**, no aquí.

### Browser navigation (lado derecho, home row)

| Tecla | Shortcut | Acción |
|-------|----------|--------|
| `M` | `⌘[` | Browser/Finder — atrás |
| `O` | `⌘]` | Browser/Finder — adelante |

### Macros tmux (lado derecho, prefix = `Ctrl+B`)

| Tecla | Secuencia tmux | Acción |
|-------|----------------|--------|
| `E` | `Ctrl+B`, `d` | Detach sesión |
| `I` | `Ctrl+B`, `z` | Zoom/unzoom pane activo |
| `,` | `Ctrl+B`, `c` | Nueva ventana |
| `.` | `Ctrl+B`, `%` | Split vertical (paneles lado a lado) |
| `/` | `Ctrl+B`, `"` | Split horizontal (paneles apilados) |

> **Nota tmux:** con HRM ya tenés `Ctrl+B` — hold `S` (→ LCTRL) + tap `B`. Los macros sirven para secuencias de dos pasos en un solo key.

### Display switching (lado derecho, fila inferior)

Requiere [Rectangle](https://rectangleapp.com/).

| Tecla | Shortcut | Acción |
|-------|----------|--------|
| `K` | `⌥⌘⇧←` | Mover ventana al display anterior |
| `H` | `⌥⌘⇧→` | Mover ventana al display siguiente |

---

## Layer 6 — Lang (hold CW/L6)

Activación: hold pulgar izquierdo externo (`CW/L6`). Todo transparente excepto el home row izquierdo.

| Tecla | Dead key | Cómo usarlo |
|-------|----------|-------------|
| A — `´` | `⌥E` dead acute | hold CW/L6 → tap A → suelta → escribe vocal → `á/é/í/ó/ú` |
| R — `~` | `⌥N` dead tilde | hold CW/L6 → tap R → suelta → escribe N → `ñ` |
| S — `¨` | `⌥U` dead umlaut | hold CW/L6 → tap S → suelta → escribe U → `ü` |
| T — `¿` | directo | hold CW/L6 → tap T → `¿` |
| G — `¡` | directo | hold CW/L6 → tap G → `¡` |

---

## Layer 7 — Apps (hold MO7)

Activación: hold `MO7` (pulgar izq-medio) desde cualquier layer — single key, sin tap.  
El lado derecho hereda Layer 2 — flechas y mouse siguen activos.

### WezTerm (top row: Q–P)

| Tecla | Shortcut | Acción |
|-------|----------|--------|
| `Q` | `⌘+T` | Nueva tab |
| `W` | `⌘+W` | Cerrar tab/pane |
| `F` | `⌘+D` | Split pane vertical |
| `P` | `⌘+Shift+D` | Split pane horizontal |

### Zoom (home row: A–T)

| Tecla | Shortcut | Acción |
|-------|----------|--------|
| `A` | `⌘+Shift+A` | Mute/unmute audio |
| `R` | `⌘+Shift+V` | Video on/off |
| `S` | `⌘+Shift+S` | Compartir pantalla |
| `T` | `⌘+Shift+H` | Salir del meeting |

### Claude Desktop + Slack (bot row: Z–D)

| Tecla | Shortcut | Acción |
|-------|----------|--------|
| `Z` | `⌘+N` | Claude Desktop — nueva conversación |
| `X` | `⌘+Shift+M` | Slack — menciones |
| `C` | `⌘+Shift+C` | Slack — format as code |
| `D` | `⌘+K` | Slack — jump to conversation |

### Focus-or-launch — Hammerspoon (lado derecho, fila superior)

Requiere [Hammerspoon](https://www.hammerspoon.org/) con `hammerspoon/init.lua` (symlink via `scripts/setup-hammerspoon.sh`).

| Tecla | Shortcut | Acción |
|-------|----------|--------|
| `M` | `⌥⌘⇧+H` | **Abrir/cerrar keymap reference** (popup interactivo con todas las capas) |
| `J` | `⌥⌘⇧+W` | Focus-or-launch WezTerm |
| `L` | `⌥⌘⇧+S` | Focus-or-launch Slack |
| `U` | `⌥⌘⇧+Z` | Focus-or-launch Zoom |
| `Y` | `⌥⌘⇧+C` | Focus-or-launch Chrome |
| `;` | `⌘+\`` | Ciclar ventanas de la app activa |

> El popup de `HELP` también es accesible desde cualquier capa pulsando `⌥⌘⇧H` directamente. Muestra un grid interactivo de todas las capas y destaca las teclas presionadas en tiempo real.

---

## OLED — Widgets activos

### Left OLED (central)

| Widget | Descripción |
|--------|-------------|
| Layer name | Nombre de la capa activa (`Base` / `Sym` / `Nav` / `Sys` / `Fn` / `Mac` / `Lang` / `Apps`) |
| Bongo Cat | Idle: gato en reposo — typing: gato animado según WPM |

### Right OLED (periférico)

| Widget | Descripción |
|--------|-------------|
| Battery | Nivel de batería |
| Peripheral cat | Animación propia del lado periférico |

---

## Power Management

| Evento | Tiempo | Acción |
|--------|--------|--------|
| Inactividad | 30 s | Apaga display (OLED) — se despierta con cualquier tecla |
| Inactividad | 5 min | Deep sleep — se despierta **solo con doble-tap en reset físico** |
| RGB Underglow | — | **Apagado por default** — toggle manual en Layer 3 (`RGB-T`) |
| Batería | — | Reporta nivel cada 60s |

> Deep sleep activo — protege contra activaciones accidentales durante transporte.

---

## Versiones fijadas

| Componente | Versión | Motivo |
|---|---|---|
| ZMK Firmware | `v0.3.0` | Estable — pre Zephyr 4.1 migration |
| zmk-nice-oled | `v0.0.2` | Testeado con ZMK v0.3.0 |
| Workflow CI | `@v0.3.0` | Consistente con versión del firmware |

---

## Setup en máquina nueva

Al conectar el teclado en una Mac por primera vez, estos pasos activan todos los shortcuts del keymap.

### 1. Hammerspoon (Layer 7 — focus-or-launch + keymap popup)

```bash
# Instala Hammerspoon (si no está) y crea el symlink
bash scripts/setup-hammerspoon.sh
```

Shortcuts disponibles tras el setup: `⌥⌘⇧W/S/Z/C` (apps) y `⌥⌘⇧H` (keymap popup).  
No requiere configuración adicional — todo está en `hammerspoon/init.lua`.

---

### 2. Rectangle (Layer 5 — window management)

Instalar desde [rectangleapp.com](https://rectangleapp.com/) o `brew install --cask rectangle`.

Los shortcuts `⌥⌘←/→/↑/↓/F/⌫` funcionan con los defaults de Rectangle.  
Solo hay que configurar los de display switching:

**Rectangle Preferences → Shortcuts:**

| Acción | Shortcut a asignar |
|--------|-------------------|
| Move to Previous Display | `⌥⌘⇧←` |
| Move to Next Display | `⌥⌘⇧→` |

---

### 3. Mission Control (Layer 5 — escritorios y espacios)

**Ajustes del sistema → Teclado → Atajos de teclado → Mission Control:**

| Shortcut | Acción | Estado default |
|----------|--------|----------------|
| `^1` … `^5` | Cambiar al Escritorio 1–5 | ☐ desactivado — **activar** |
| `^←` | Moverse al espacio a la izquierda | ☐ desactivado — **activar** |
| `^→` | Moverse al espacio a la derecha | ☐ desactivado — **activar** |
| `^⇧←` | Mover ventana al espacio anterior | ☐ desactivado — **activar** |
| `^⇧→` | Mover ventana al espacio siguiente | ☐ desactivado — **activar** |
| `^↑` | Mission Control | ✓ ya activo |
| `^↓` | Exposé de la app | ✓ ya activo |

> Nota: los escritorios `^1-5` solo aparecen en la lista cuando Mission Control tiene espacios fijos. Activar **"Organizar espacios automáticamente"** + crear al menos 5 escritorios primero.

---

### Checklist de setup rápido

- [ ] `bash scripts/setup-hammerspoon.sh` ejecutado
- [ ] Hammerspoon tiene permisos de Accesibilidad (Ajustes → Privacidad → Accesibilidad)
- [ ] Rectangle instalado
- [ ] Rectangle: Move to Previous/Next Display → `⌥⌘⇧←/→`
- [ ] Mission Control: activar `^1-5`, `^←/→`, `^⇧←/→`

---

## Compilación y flash

El firmware se compila automáticamente via GitHub Actions en cada push.  
Los artefactos (`.uf2`) se descargan desde la pestaña **Actions**.

Para flashear desde el teclado: **Layer 3** (combo `SPC+MO2`) → tecla `BOOT`.
