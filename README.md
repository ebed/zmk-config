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

## Layout Base — Colemak-DH con Home Row Mods

El layout base es **Colemak-DH**, optimizado para ergonomía. Los modificadores están en la home row via **hold-tap** (mantener = modificador, tap = letra).

```
,------------------------------------------.        ,-----------------------------------------.
| ESC  |  Q  |  W  |  F  |  P   |  B      |        |  J   |  L  |  U  |  Y  |  ;  | BSPC  |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| TAB  |GUI/A|ALT/R|CTL/S|SHF/T |  G      |        |  M   |SHF/N|CTL/E|ALT/I|GUI/O|  '    |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| CTRL |  Z  |  X  |  C  |  D   |  V      |        |  K   |  H  |  ,  |  .  |  /  | RET   |
'------+-----+-----+-----+------+---------'        '------+-----+-----+-----+-----+-------'
             |CPSW | GUI | SPACE|                        | MO2 | MO1 |RALT |
             '-----+-----+------'                        '-----+-----+-----'
```

### Home Row Mods (HRM)

| Posición | Tap | Hold |
|----------|-----|------|
| A (pinky izq) | `a` | `LGUI` (Cmd/Win) |
| R (anular izq) | `r` | `LALT` |
| S (medio izq) | `s` | `LCTRL` |
| T (índice izq) | `t` | `LSHFT` |
| N (índice der) | `n` | `RSHFT` |
| E (medio der) | `e` | `RCTRL` |
| I (anular der) | `i` | `RALT` |
| O (pinky der) | `o` | `RGUI` |

**Timings anti-misfire:**
- `tapping-term-ms = 200` — tap/hold en <200ms = siempre tap
- `quick-tap-ms = 175` — doble-tap rápido = siempre tap
- `require-prior-idle-ms = 150` — si venías tipeando, nunca activa hold

**Caps Word** (`CPSW`): activa modo ALL_CAPS automático. Escribe letras en mayúscula + `_` sin mantener shift. Se desactiva solo al presionar espacio u otro símbolo.

---

## Capas

### Layer 1 — Números / Símbolos (`MO1`)

```
,-----------------------------------------.        ,-----------------------------------------.
|      |  1  |  2  |  3  |  4  |  5      |        |  6  |  7  |  8  |  9  |  0  | DEL   |
|------+-----+-----+-----+-----+---------|        |-----+-----+-----+-----+-----+-------|
| TAB  |     |     |     |     |         |        |  -  |  =  |     |     |  \  |  `    |
|------+-----+-----+-----+-----+---------|        |-----+-----+-----+-----+-----+-------|
|      |     |     |     |     |         |        |  [  |  ]  |     |     |     | RET   |
'------+-----+-----+-----+-----+---------'        '-----+-----+-----+-----+-----+-------'
             |CPSW | GUI | SPACE|                       | MO3 |     |RALT |
             '-----+-----+------'                       '-----+-----+-----'
```

### Layer 2 — Navegación / Mouse (`MO2`)

```
,-----------------------------------------.        ,-----------------------------------------.
|SCRUP |     | M↑  |     |LCLK |         |        |     | ↑   |     |     |     | BSPC  |
|------+-----+-----+-----+-----+---------|        |-----+-----+-----+-----+-----+-------|
|SCRDN | M←  | M↓  | M→  |MCLK |         |        | ←   | ↓   | →   |HOME |PGUP |       |
|------+-----+-----+-----+-----+---------|        |-----+-----+-----+-----+-----+-------|
|SC←   |SC→  |     |     |RCLK |         |        |     |     |     |END  |PGDN |       |
'------+-----+-----+-----+-----+---------'        '-----+-----+-----+-----+-----+-------'
             |     | GUI | SPACE|                       |     | MO4 |RALT |
             '-----+-----+------'                       '-----+-----+-----'
```

Mouse en la mano izquierda, flechas en la derecha. Scroll horizontal y vertical disponibles.

### Layer 3 — Sistema (`MO1` + `MO3`)

```
,-----------------------------------------.        ,-----------------------------------------.
|BTCLR |     |     |     | BLE | USB     |        |     |     |     |     |BLTG | RGBT  |
|------+-----+-----+-----+-----+---------|        |-----+-----+-----+-----+-----+-------|
|SOFF  | BT0 | BT1 | BT2 |     |         |        |RGBE |     | BL- | BL+ |RGB- |RGB+   |
|------+-----+-----+-----+-----+---------|        |-----+-----+-----+-----+-----+-------|
|BOOT  | BT3 | BT4 | BT5 |     |         |        |RGB🟢|RGB🔴|RGB🔵|RGB🟡|     |       |
'------+-----+-----+-----+-----+---------'        '-----+-----+-----+-----+-----+-------'
             | GUI |     | SPACE|                       | RET |     |RALT |
             '-----+-----+------'                       '-----+-----+-----'
```

- `BTCLR`: borra el perfil BT activo
- `SOFF`: soft-off (apagado profundo)
- `BOOT`: entra en modo bootloader para flashear firmware
- `BT0–BT5`: selecciona perfil Bluetooth

### Layer 4 — Funciones (`MO2` + `MO4`)

```
,-----------------------------------------.        ,-----------------------------------------.
| F1   | F2  | F3  | F4  | F5  | F6      |        | F7  | F8  | F9  | F10 | F11 | F12   |
|------+-----+-----+-----+-----+---------|        |-----+-----+-----+-----+-----+-------|
|      |     |     |     |     |         |        |     |     |     |     |     |       |
|------+-----+-----+-----+-----+---------|        |-----+-----+-----+-----+-----+-------|
|      |     |     |     |     |         |        |     |     |     |     |     |       |
'------+-----+-----+-----+-----+---------'        '-----+-----+-----+-----+-----+-------'
             |     |     |     |                        |     |     |     |
             '-----+-----+-----'                        '-----+-----+-----'
```

---

## Power Management

| Evento | Tiempo | Acción |
|--------|--------|--------|
| Inactividad | 5 min | Apaga display y RGB |
| Inactividad | 15 min | Deep sleep (Soft-off) |
| USB conectado | — | RGB siempre activo |

---

## Versiones fijadas

| Componente | Versión | Motivo |
|---|---|---|
| ZMK Firmware | `v0.3.0` | Estable — pre Zephyr 4.1 migration |
| zmk-nice-oled | `v0.0.2` | Testeado con ZMK v0.3.0 |
| Workflow CI | `@v0.3.0` | Consistente con versión del firmware |

---

## Compilación

El firmware se compila automáticamente via GitHub Actions en cada push. Los artefactos (`.uf2`) se descargan desde la pestaña **Actions** del repositorio.

Para flashear:
1. Descargar el `.uf2` del lado correspondiente (left/right)
2. Conectar el teclado por USB manteniendo reset
3. Aparece como drive USB — arrastrar el `.uf2`
4. Para entrar en bootloader desde el teclado: **Layer 3** → `BOOT`
