# Layouts — Visual Reference

ASCII art de todas las capas. Para explicaciones, comportamientos y shortcuts ver [README.md](README.md).

---

## Layer 0 — Base (Colemak-DH + HRM)

```
,------------------------------------------.        ,-----------------------------------------.
|gresc |  Q  |  W  |  F  |  P   |  B      |        |  J   |  L  |  U  |  Y  |  ;  |BSP/L4 |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| TAB  |GUI/A|ALT/R|CTL/S|SHF/T |  G      |        |  M   |SHF/N|CTL/E|ALT/I|GUI/O|  '    |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| REPT |  Z  |  X  |  C  |  D   |  V      |        |  K   |  H  |  ,  |  .  |  /  | MO3   |
'------+-----+-----+-----+------+---------'        '------+-----+-----+-----+-----+-------'
             |CW/L6 | MO7 |SPACE|                      |RET/L5| MO2 | MO1|
             '------+-----+-----'                       '------+-----+----'
```

- `gresc`: tap=ESC, Shift+tap=`~`
- `REPT`: repite el último key (`&key_repeat`) — meñique izquierdo inferior
- `BSP/L4`: tap=⌫ / hold=Layer 4 (Fn)
- `MO3`: meñique derecho inferior → Layer 3 (Sys) directo — BT, media, lock
- `CW/L6`: tap=CapsWord / hold=Layer 6 (Lang)
- `MO7`: hold=Layer 7 (Apps) — Ctrl viene del HRM en `S`
- `RET/L5`: tap=↵ RET / hold=Layer 5 (Mac)
- Combo `SPC+MO2` (pos 38+40) → Layer 3 (Sys)
- HRM (home row): tap=letra, hold=mod (GUI/ALT/CTL/SHF)

---

## Layer 1 — Sym (hold MO1)

```
,---------------------------------------------.        ,--------------------------------------------.
| REPT |1/!  |2/@   |3/#   |4/$   |5/%        |        |6/^   |7/&  |8/*   |9/(   |0/)   | DEL   |
|------+-----+------+------+------+-----------|        |------+-----+------+------+------+-------|
| TAB  |  !  |  @   |  #   |  $   |  %        |        |  -   |  =  |  ^   |  |   |  \   |  `    |
|------+-----+------+------+------+-----------|        |------+-----+------+------+------+-------|
|  SK  |  &  |  *   |  (   |  )   |  _        |        |  [   |  ]  |  {   |  }   |  +   | RET   |
'------+-----+------+------+------+-----------'        '------+-----+------+------+------+-------'
             |CW/L6 | MO7  | SPACE|                         | MO3 | TOG1 |     |
             '------+------+------'                         '-----+------+-----'
```

- `REPT` (`&key_repeat`): repite el último key en cualquier layer
- `1/!` … `0/)`: tap=número, hold=símbolo Shift+número
- `SK`: Sticky Shift (tap=1 char, doble=sticky, triple=CapsLock)
- `TOG1` (`&tog 1`): bloquea/desbloquea Layer 1 — hold MO1 + tap MO2

---

## Layer 2 — Nav (hold MO2)

```
,--------------------------------------------.        ,---------------------------------------------.
|SCRL↑ |     | M↑  |     | LCLK |            |        |⇧HOME| WJ← | ↑   | WJ→ |⇧END | BSPC  |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SCRL↓ | M←  | M↓  | M→  | MCLK |            |        |     | ←   | ↓   | →   |HOME | PGUP  |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SCRL← |SCRL→|     |     | RCLK |            |        |SEL↑ |SEL← |SEL↓ |SEL→ |END  | PGDN  |
'------+-----+-----+-----+------+------------'        '-----+-----+-----+-----+-----+-------'
             |     |     |      |                           | MO4 |[hld]|     |
             '-----+-----+------'                           '-----+-----+-----'
```

- Izquierdo: mouse (movimiento, scroll, clics)
- Derecho fila 1: `⇧HOME`=sel inicio línea · `WJ←/→`=⌥←/→ (word jump) · `⇧END`=sel fin línea
- Derecho fila 3: `SEL↑/←/↓/→` = Shift+flecha
- Layer 7 (Apps): hold `MO7` (izq-medio) desde cualquier layer
- `MO4` (inner right) + `BSP/L4` (hold BSPC) → ambas rutas a Fn layer

---

## Layer 3 — Sys (MO1 + MO3)

```
,--------------------------------------------.        ,--------------------------------------------.
|BTCLR |PRV  |PLAY |NXT  | BLE  | USB        |        |BRI- |BRI+ |     |     |BL-TG| RGB-T |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SOFF  | BT0 | BT1 | BT2 |VOL-  |VOL+        |        |RGB+ |     | BL- | BL+ |RGB- | RGB++ |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|BOOT  | BT3 | BT4 | BT5 |MUTE  |LCK         |        | 🟢  | 🔴  | 🔵  | 🟡  |     |       |
'------+-----+-----+-----+------+------------'        '-----+-----+-----+-----+-----+-------'
             | GUI |     | SPACE|                           | RET |     |RALT |
             '-----+-----+------'                           '-----+-----+-----'
```

- `BRI-/BRI+`: brillo de pantalla
- `RGB-T`: toggle RGB underglow
- `BL-TG`: toggle backlight
- `SOFF`: soft-off (deep sleep)
- `BOOT`: modo bootloader para flashear

---

## Layer 4 — Fn (MO2 + MO4)

```
,--------------------------------------------.        ,--------------------------------------------.
|  F1  |  F2 |  F3 |  F4 |  F5  |  F6        |        |  F7  |  F8 |  F9 | F10 | F11 |  F12  |
|------+-----+-----+-----+------+------------|        |------+-----+-----+-----+-----+-------|
|      |     |     |     |      |            |        |      |     |     |     |     |       |
|------+-----+-----+-----+------+------------|        |------+-----+-----+-----+-----+-------|
|      |     |     |     |      |            |        |      |     |     |     |     |       |
'------+-----+-----+-----+------+------------'        '------+-----+-----+-----+-----+-------'
             |     |     |      |                           |      |[hld]|     |
             '-----+-----+------'                           '------+-----+-----'
```

- F1–F12 en la fila superior
- `[hld]` = MO4 (mantenido desde Layer 2 para activar esta capa)

---

## Layer 5 — Mac (hold SYM/5)

```
,----------------------------------------------.        ,--------------------------------------------.
|DSK1 |DSK2 |DSK3  |DSK4  |DSK5  | HDE        |        |WIN← |WIN→ |WIN↑  |WIN↓  |MAX   | RST   |
|-----+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
| FQ  |SS📋  |SS⌘4  | UND  | RED  |MCrl        |        | BCK |CTR  |tmx:dt|tmx:zm| FWD  |       |
|-----+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
|     |DSK← |DSK→  |Exposé| MW←  | MW→        |        |DISP←|DISP→|tmx:nw|tmx:% |tmx:" |       |
'-----+-----+------+------+------+------------'        '-----+-----+------+------+------+-------'
             |      | GUI  | SPACE|                         |      |      |[held]|
             '------+------+------'                         '------+------+------'
```

- Izquierdo: escritorios (DSK1-5), hide others, screenshots, undo/redo, Mission Control
- Derecho: Rectangle (WIN←→↑↓ MAX RST), browser nav (BCK/FWD), tmux, display switch (DISP←/→)
- `UND`=⌘Z, `RED`=⌘⇧Z, `BCK`=⌘[, `FWD`=⌘], `FQ`=Force Quit, `MCrl`=Mission Control
- `DISP←`=⌥⌘⇧← (mover ventana a display anterior), `DISP→`=⌥⌘⇧→ (siguiente display) — configurar en Rectangle Preferences → Shortcuts

---

## Layer 6 — Lang (hold CPSW)

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

- Todo transparente excepto home row izquierdo
- `´` = dead acute (⌥E) → vocal → á/é/í/ó/ú
- `~` = dead tilde (⌥N) → n → ñ
- `¨` = dead umlaut (⌥U) → u → ü
- `¿` y `¡` = directos

---

## Layer 7 — Apps (hold MO7)

```
,--------------------------------------------.        ,--------------------------------------------.
|     |WTAB |WCLS |WSPL-V|WSPL-H|            |        | WEZ | SLK | ZOM | CHR |CYCL | BSPC  |
|-----+-----+-----+------+------+------------|        |-----+-----+-----+-----+-----+-------|
|     |ZMUT |ZVID |ZSHR  |ZLVE  |            |        |HELP | ←   | ↓   | →   |HOME | PGUP  |
|-----+-----+-----+------+------+------------|        |-----+-----+-----+-----+-----+-------|
|     |CLNEW|SMEN |SCOD  |SJMP  |            |        |     |SEL← |SEL↓ |SEL→ |END  | PGDN  |
'-----+-----+-----+------+------+------------'        '-----+-----+-----+-----+-----+-------'
             |CW/L6|[held]|      |                         |RET/L5| MO2 | MO1|
             '-----+------+------'                         '------+-----+----'
```

- Activación: hold `MO7` (izq-medio, sin tap) desde cualquier layer — single key, sin combo
- Izq top row: WezTerm (Q-P), B vacío
- Izq home row: Zoom completo en A-T (mute/video/share/leave), G vacío
- Izq bot row: Claude (Z) + Slack (X=menciones, C=code, D=jump)
- Der fila superior: focus-or-launch vía Hammerspoon (`⌥⌘⇧` + letra)
- Der resto: transparente — hereda Layer 2 Nav (flechas siguen funcionando)

| Key | Shortcut | App | Acción |
|-----|----------|-----|--------|
| `Q` — WTAB | `⌘+T` | WezTerm | Nueva tab |
| `W` — WCLS | `⌘+W` | WezTerm | Cerrar tab/pane |
| `F` — WSPL-V | `⌘+D` | WezTerm | Split vertical |
| `P` — WSPL-H | `⌘+Shift+D` | WezTerm | Split horizontal |
| `A` — ZMUT | `⌘+Shift+A` | Zoom | Mute/unmute |
| `R` — ZVID | `⌘+Shift+V` | Zoom | Video on/off |
| `S` — ZSHR | `⌘+Shift+S` | Zoom | Screen share |
| `T` — ZLVE | `⌘+Shift+H` | Zoom | Salir del meeting |
| `Z` — CLNEW | `⌘+N` | Claude Desktop | Nueva conversación |
| `X` — SMEN | `⌘+Shift+M` | Slack | Menciones |
| `C` — SCOD | `⌘+Shift+C` | Slack | Format as code |
| `D` — SJMP | `⌘+K` | Slack/WezTerm | Jump to / clear |
| `M` — HELP | `⌥⌘⇧+H` | Hammerspoon | Popup: árbol de acceso a capas |
| `J` — WEZ | `⌥⌘⇧+W` | Hammerspoon | Focus-or-launch WezTerm |
| `L` — SLK | `⌥⌘⇧+S` | Hammerspoon | Focus-or-launch Slack |
| `U` — ZOM | `⌥⌘⇧+Z` | Hammerspoon | Focus-or-launch Zoom |
| `Y` — CHR | `⌥⌘⇧+C` | Hammerspoon | Focus-or-launch Chrome |
| `;` — CYCL | `⌘+\`` | macOS | Ciclar ventanas de la app activa |

---

## Leyenda

| Símbolo | Significado |
|---------|-------------|
| `GUI/A` | tap=A, hold=Cmd |
| `ALT/R` | tap=R, hold=Alt |
| `CTL/S` | tap=S, hold=Ctrl |
| `SHF/T` | tap=T, hold=Shift |
| `1/!` | tap=1, hold=! |
| `BSP/L4` | tap=⌫, hold=Layer 4 (Fn) |
| `REPT` | repite el último key (`&key_repeat`) |
| `CW/L6` | tap=CapsWord, hold=Layer 6 (Lang) |
| `MO7` | hold=Layer 7 (Apps) — sin tap |
| `RET/L5` | tap=↵ RET, hold=Layer 5 (Mac) |
| `MO1/2/4` | momentáneo — activo mientras se mantiene |
| `TOG1` | toggle Layer 1 (lock/unlock sin mantener) |
| `[held]` | tecla mantenida para activar la capa |
| `SPC+MO2` | combo (left inner + right middle) → Layer 3 (Sys) |
| `WJ←/→` | word jump (⌥←/→) |
| `⇧HOME` / `⇧END` | selección al inicio/fin de línea |
| `SEL↑/←/↓/→` | selección de texto (Shift+flecha) |
