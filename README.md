# Corne Keyboard — ZMK Config

Configuración personalizada para teclado Corne (CRKBD) split 42 teclas usando [ZMK Firmware](https://zmk.dev/) v0.3.0.

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
  └─ hold MO1 (pulgar der medio) → Sym (Layer 1)
       └─ tap MO3 (pulgar der izq) → Sys (Layer 3)
       └─ tap outer-right thumb (TOG1) → bloquea Layer 1 (numpad mode)
  └─ hold MO2 (pulgar der izq) → Nav (Layer 2)
       └─ tap MO4 (pulgar der med) → Fn (Layer 4)
  └─ hold outer-right thumb → Mac (Layer 5)
  └─ tap outer-right thumb → Sticky Layer 1 (un símbolo sin hold)
  └─ tap CPSW → CapsWord / hold CPSW → Lang (Layer 6)
```

---

## Layer 0 — Base (Colemak-DH + Home Row Mods)

```
,------------------------------------------.        ,-----------------------------------------.
|gresc |  Q  |  W  |  F  |  P   |  B      |        |  J   |  L  |  U  |  Y  |  ;  | BSPC  |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| TAB  |GUI/A|ALT/R|CTL/S|SHF/T |  G      |        |  M   |SHF/N|CTL/E|ALT/I|GUI/O|  '    |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| CTRL |  Z  |  X  |  C  |  D   |  V      |        |  K   |  H  |  ,  |  .  |  /  | RET   |
'------+-----+-----+-----+------+---------'        '------+-----+-----+-----+-----+-------'
             |CPSW | GUI | SPACE|                        | MO2 | MO1 |SYM/5|
             '-----+-----+------'                        '-----+-----+-----'
```

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

### `SYM/5` — Outer right thumb (sticky sym / Mac layer)

| Input | Output |
|-------|--------|
| Tap | Sticky Layer 1 — activa Sym para el siguiente keypress, luego vuelve a Base |
| Hold | Layer 5 (Mac shortcuts / Rectangle / tmux) |

### `CPSW` — Caps Word + Layer 6

| Input | Output |
|-------|--------|
| Tap | Caps Word (letras en mayúscula hasta espacio o símbolo) |
| Hold | Layer 6 (Lang/Español) — libera para volver a Base |

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

```
,---------------------------------------------.        ,--------------------------------------------.
| REPT |1/!  |2/@   |3/#   |4/$   |5/%        |        |6/^   |7/&  |8/*   |9/(   |0/)   | DEL   |
|------+-----+------+------+------+-----------|        |------+-----+------+------+------+-------|
| TAB  |  !  |  @   |  #   |  $   |  %        |        |  -   |  =  |  ^   |  |   |  \   |  `    |
|------+-----+------+------+------+-----------|        |------+-----+------+------+------+-------|
|  SK  |  &  |  *   |  (   |  )   |  _        |        |  [   |  ]  |  {   |  }   |  +   | RET   |
'------+-----+------+------+------+-----------'        '------+-----+------+------+------+-------'
             | CPSW | GUI  | SPACE|                         | MO3 |      | TOG1 |
             '------+------+------'                         '-----+------+------'
```

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

```
,--------------------------------------------.        ,--------------------------------------------.
|SCRL↑ |     | M↑  |     | LCLK |            |        |     | WJ← | ↑   | WJ→ |     | BSPC  |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SCRL↓ | M←  | M↓  | M→  | MCLK |            |        |     | ←   | ↓   | →   |HOME | PGUP  |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SCRL← |SCRL→|     |     | RCLK |            |        |     |SEL← |SEL↓ |SEL→ |END  | PGDN  |
'------+-----+-----+-----+------+------------'        '-----+-----+-----+-----+-----+-------'
             |     | GUI | SPACE|                           |     | MO4 |     |
             '-----+-----+------'                           '-----+-----+-----'
```

Mouse en la mano izquierda — click, scroll y movimiento. Flechas + navegación en la derecha.

Velocidad del mouse: `1500` (default ZMK: 600). Scroll: `20`.

| Key | Acción |
|-----|--------|
| `WJ←` / `WJ→` | Word jump — `Ctrl+←/→` (saltar palabra) |
| `←` `↓` `↑` `→` | Flechas normales |
| `SEL←` `SEL↓` `SEL→` | Selección de texto — `Shift+←/↓/→` |
| `HOME` / `END` | Inicio / fin de línea |
| `PGUP` / `PGDN` | Página arriba / abajo |

---

## Layer 3 — Sys (MO1 + MO3)

```
,--------------------------------------------.        ,--------------------------------------------.
|BTCLR |PRV  |PLAY |NXT  | BLE  | USB        |        |BRI- |BRI+ |     |     |BL-TG| RGB-T |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SOFF  | BT0 | BT1 | BT2 |VOL-  |VOL+        |        |RGB+ |     | BL- | BL+ |RGB- | RGB++ |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|BOOT  | BT3 | BT4 | BT5 |MUTE  |LCK         |        |🟢   | 🔴  | 🔵  | 🟡  |     |       |
'------+-----+-----+-----+------+------------'        '-----+-----+-----+-----+-----+-------'
             | GUI |     | SPACE|                           | RET |     |RALT |
             '-----+-----+------'                           '-----+-----+-----'
```

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

## Layer 4 — Fn (MO2 + MO4)

F1–F12 en la fila superior.

---

## Layer 5 — Mac (hold outer-right thumb)

Activación: hold pulgar derecho externo (`SYM/5`).

```
,----------------------------------------------.        ,--------------------------------------------.
|DSK1 |DSK2 |DSK3  |DSK4  |DSK5  | HDE        |        |WIN← |WIN→ |WIN↑  |WIN↓  |MAX   | RST   |
|-----+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
| FQ  |SS📋  |SS⌘4  | UND  | RED  |MCrl        |        | BCK |CTR  |tmx:dt|tmx:zm| FWD  |       |
|-----+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
|     |DSK← |DSK→  |Exposé| MW←  | MW→        |        |     |     |tmx:nw|tmx:% |tmx:" |       |
'-----+-----+------+------+------+------------'        '-----+-----+------+------+------+-------'
             |      | GUI  | SPACE|                         |      |      |[held]|
             '------+------+------'                         '------+------+------'
```

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

---

## Layer 6 — Lang (hold CPSW)

Activación: hold pulgar izquierdo externo. Todo transparente excepto el home row izquierdo.

```
,---------------------------------------------.        ,--------------------------------------------.
|      |     |      |      |      |            |        |     |     |      |      |      |       |
|------+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
|      |  ´  |  ~   |  ¨   |  ¿   |  ¡         |        |     |     |      |      |      |       |
|------+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
|      |     |      |      |      |            |        |     |     |      |      |      |       |
'------+-----+------+------+------+------------'        '-----+-----+------+------+------+-------'
             |[held]|      |      |                         |      |      |      |
             '------+------+------'                         '------+------+------'
```

| Tecla | Dead key | Cómo usarlo |
|-------|----------|-------------|
| A — `´` | `⌥E` dead acute | hold CPSW → tap A → suelta CPSW → escribe vocal → `á/é/í/ó/ú` |
| R — `~` | `⌥N` dead tilde | hold CPSW → tap R → suelta CPSW → escribe N → `ñ` |
| S — `¨` | `⌥U` dead umlaut | hold CPSW → tap S → suelta CPSW → escribe U → `ü` |
| T — `¿` | directo | hold CPSW → tap T → `¿` |
| G — `¡` | directo | hold CPSW → tap G → `¡` |

---

## OLED — Widgets activos

### Left OLED (central)

| Widget | Descripción |
|--------|-------------|
| Layer name | Nombre de la capa activa (`Base` / `Sym` / `Nav` / `Sys` / `Fn` / `Mac`) |
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

## Compilación y flash

El firmware se compila automáticamente via GitHub Actions en cada push.  
Los artefactos (`.uf2`) se descargan desde la pestaña **Actions**.

Para flashear desde el teclado: **Layer 3** (`MO1` + `MO3`) → tecla `BOOT`.
