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
  └─ hold MO1 (pulgar der medio) → Nums (Layer 1)
       └─ tap MO3 (pulgar der izq) → Sys (Layer 3)
  └─ hold MO2 (pulgar der izq) → Nav (Layer 2)
       └─ tap MO4 (pulgar der med) → Fn (Layer 4)
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
             |CPSW | GUI | SPACE|                        | MO2 | MO1 |RALT |
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

**Timings:** `tapping-term=280ms` · `quick-tap=175ms` · `require-prior-idle=150ms` · flavor `balanced`

> Si hay misfires al tipear → subir `require-prior-idle-ms` a 200.
> Si los mods se activan tarde → bajar `tapping-term-ms` a 230.

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

## Layer 1 — Nums (hold MO1)

```
,--------------------------------------------.        ,--------------------------------------------.
|      |  1  |  2   |  3   |  4   |  5       |        |  6   |  7  |  8    |  9    |  0   | DEL   |
|------+-----+------+------+------+----------|        |------+-----+-------+-------+------+-------|
| TAB  |     |SS⌘4  |SS⌘3  |SS⌘5  |Mission   |        |  -   |  =  |tmx:dt |tmx:zm |  \   |  `    |
|------+-----+------+------+------+----------|        |------+-----+-------+-------+------+-------|
|      |DSK← |DSK→  |Exposé|      |          |        |  [   |  ]  |tmx:nw |tmx:%  |tmx:" | RET   |
'------+-----+------+------+------+----------'        '------+-----+-------+-------+------+-------'
             |CPSW  | GUI  | SPACE|                         | MO3 |       |RALT   |
             '------+------+------'                         '-----+-------+-------'
```

### Shortcuts macOS (lado izquierdo)

| Tecla (Layer 1) | Shortcut | Acción |
|-----------------|----------|--------|
| `R` | `⌘+Shift+4` | Screenshot — selección de área |
| `S` | `⌘+Shift+3` | Screenshot — pantalla completa |
| `T` | `⌘+Shift+5` | Screenshot — toolbar (video/área) |
| `G` | `Ctrl+↑` | Mission Control |
| `Z` | `Ctrl+←` | Escritorio anterior |
| `X` | `Ctrl+→` | Escritorio siguiente |
| `C` | `Ctrl+↓` | App Exposé (ventanas de la app activa) |

### Macros tmux (lado derecho, prefix = `Ctrl+B`)

| Tecla (Layer 1) | Secuencia tmux | Acción |
|-----------------|----------------|--------|
| `E` (col 8) | `Ctrl+B`, `d` | Detach sesión |
| `I` (col 9) | `Ctrl+B`, `z` | Zoom/unzoom pane activo |
| `,` (col 8 bot) | `Ctrl+B`, `c` | Nueva ventana |
| `.` (col 9 bot) | `Ctrl+B`, `%` | Split vertical (paneles lado a lado) |
| `/` (col 10 bot) | `Ctrl+B`, `"` | Split horizontal (paneles apilados) |

> **Nota tmux:** con HRM ya tenés `Ctrl+B` en cualquier layer — hold `S` (→ LCTRL) + tap `B`. Los macros sirven para secuencias de dos pasos (prefix + acción) en un solo key.

---

## Layer 2 — Nav (hold MO2)

```
,--------------------------------------------.        ,--------------------------------------------.
|SCRL↑ |     | M↑  |     | LCLK |            |        |     | ↑   |     |     |     | BSPC  |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SCRL↓ | M←  | M↓  | M→  | MCLK |            |        | ←   | ↓   | →   |HOME |PGUP |       |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SCRL← |SCRL→|     |     | RCLK |            |        |     |     |     |END  |PGDN |       |
'------+-----+-----+-----+------+------------'        '-----+-----+-----+-----+-----+-------'
             |     | GUI | SPACE|                           |     | MO4 |RALT |
             '-----+-----+------'                           '-----+-----+-----'
```

Mouse en la mano izquierda — click, scroll y movimiento. Flechas + navegación en la derecha.

---

## Layer 3 — Sys (MO1 + MO3)

```
,--------------------------------------------.        ,--------------------------------------------.
|BTCLR |     |     |     | BLE  | USB        |        |     |     |     |     |BL-TG| RGB-T |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SOFF  | BT0 | BT1 | BT2 |      |            |        |RGB+ |     | BL- | BL+ |RGB- | RGB++ |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|BOOT  | BT3 | BT4 | BT5 |      |            |        |🟢   | 🔴  | 🔵  | 🟡  |     |       |
'------+-----+-----+-----+------+------------'        '-----+-----+-----+-----+-----+-------'
             | GUI |     | SPACE|                           | RET |     |RALT |
             '-----+-----+------'                           '-----+-----+-----'
```

| Key | Acción |
|-----|--------|
| `BTCLR` | Borra emparejamiento del perfil activo |
| `BT0–BT5` | Selecciona perfil Bluetooth |
| `BLE/USB` | Cambia output activo |
| `SOFF` | Soft-off (apagado profundo, requiere reset para despertar) |
| `BOOT` | Entra en modo bootloader para flashear firmware |

---

## Layer 4 — Fn (MO2 + MO4)

F1–F12 en la fila superior.

---

## OLED — Widgets activos

| Widget | Descripción |
|--------|-------------|
| Layer name | Nombre de la capa activa (`Base` / `Nums` / `Nav` / `Sys` / `Fn`) |
| Modifier indicators | Muestra qué HRM está activo (GUI / ALT / CTL / SHF) |
| HID indicators | CapsLock — activa animación Luna |
| WPM | Contador de palabras por minuto en tiempo real |
| Luna animation | Animada por modificadores y CapsLock |
| Battery | Nivel de batería en el lado periférico |

---

## Power Management

| Evento | Tiempo | Acción |
|--------|--------|--------|
| Inactividad | 5 min | Apaga display y RGB |
| Inactividad | 15 min | Deep sleep |
| USB conectado | — | RGB siempre activo |
| Batería | — | Reporta nivel cada 60s |

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
