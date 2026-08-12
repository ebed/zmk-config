# Layouts — Visual Reference

ASCII art de todas las capas. Para explicaciones, comportamientos y shortcuts ver [README.md](README.md).

---

## Layer 0 — Base (Colemak-DH + HRM)

```
,------------------------------------------.        ,-----------------------------------------.
|gresc |  Q  |  W  |  F  |  P   |  B      |        |  J   |  L  |  U  |  Y  |  ;  | BSPC  |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| TAB  |GUI/A|ALT/R|CTL/S|SHF/T |  G      |        |  M   |SHF/N|CTL/E|ALT/I|GUI/O|  '    |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| CTRL |  Z  |  X  |  C  |  D   |  V      |        |  K   |  H  |  ,  |  .  |  /  | RET   |
'------+-----+-----+-----+------+---------'        '------+-----+-----+-----+-----+-------'
             | CPSW| GUI | SPACE|                        | MO2 | MO1 |SYM/5|
             '-----+-----+------'                        '-----+-----+-----'
```

- `gresc`: tap=ESC, Shift+tap=`~`
- `CPSW`: tap=CapsWord / hold=Layer 6 (Lang)
- `SYM/5`: tap=Sticky Layer 1 / hold=Layer 5 (Mac)
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
             | CPSW | GUI  | SPACE|                         | MO3 |      | TOG1 |
             '------+------+------'                         '-----+------+------'
```

- `REPT` (`&key_repeat`): repite el último key en cualquier layer
- `1/!` … `0/)`: tap=número, hold=símbolo Shift+número
- `SK`: Sticky Shift (tap=1 char, doble=sticky, triple=CapsLock)
- `TOG1` (`&tog 1`): bloquea/desbloquea Layer 1 sin mantener MO1

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
             |     | GUI |  MO7 |                           |     | MO4 |     |
             '-----+-----+------'                           '-----+-----+-----'
```

- Izquierdo: mouse (movimiento, scroll, clics)
- Derecho: flechas, word-jump (`WJ←/→` = Ctrl+←/→), selección, paginación
- `SEL←` / `SEL↓` / `SEL→` = Shift+←/↓/→
- `MO7`: hold MO2 + hold MO7 (izq-interno) → Layer 7 (Apps)

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

## Layer 7 — Apps (hold MO2 + hold MO7)

```
,--------------------------------------------.        ,--------------------------------------------.
|     |WTAB |WCLS |WSPL-V|WSPL-H|ZLVE        |        |     | WJ← | ↑   | WJ→ |     | BSPC  |
|-----+-----+-----+------+------+------------|        |-----+-----+-----+-----+-----+-------|
|     |ZMUT |ZVID |ZSHR  |SCOD  |SJMP        |        |     | ←   | ↓   | →   |HOME | PGUP  |
|-----+-----+-----+------+------+------------|        |-----+-----+-----+-----+-----+-------|
|     |CLNEW|SMEN |      |      |            |        |     |SEL← |SEL↓ |SEL→ |END  | PGDN  |
'-----+-----+-----+------+------+------------'        '-----+-----+-----+-----+-----+-------'
             |     |      |[held]|                         |     | MO4 |     |
             '-----+------+------'                         '-----+-----+-----'
```

- Activación: hold `MO2` (der-interno) + hold `MO7` (izq-interno, era SPACE en Nav)
- Derecho: transparente — hereda Layer 2 Nav (flechas y mouse siguen funcionando)

| Key | Shortcut | App | Acción |
|-----|----------|-----|--------|
| `Q` — WTAB | `⌘+T` | WezTerm | Nueva tab |
| `W` — WCLS | `⌘+W` | WezTerm | Cerrar tab/pane |
| `F` — WSPL-V | `⌘+D` | WezTerm | Split vertical |
| `P` — WSPL-H | `⌘+Shift+D` | WezTerm | Split horizontal |
| `B` — ZLVE | `⌘+Shift+H` | Zoom | Salir del meeting |
| `A` — ZMUT | `⌘+Shift+A` | Zoom | Mute/unmute |
| `R` — ZVID | `⌘+Shift+V` | Zoom | Video on/off |
| `S` — ZSHR | `⌘+Shift+S` | Zoom | Screen share |
| `T` — SCOD | `⌘+Shift+C` | Slack | Format as code |
| `G` — SJMP | `⌘+K` | Slack/WezTerm | Jump to / clear |
| `Z` — CLNEW | `⌘+N` | Claude Desktop | Nueva conversación |
| `X` — SMEN | `⌘+Shift+M` | Slack | Menciones |

---

## Leyenda

| Símbolo | Significado |
|---------|-------------|
| `GUI/A` | tap=A, hold=Cmd |
| `ALT/R` | tap=R, hold=Alt |
| `CTL/S` | tap=S, hold=Ctrl |
| `SHF/T` | tap=T, hold=Shift |
| `1/!` | tap=1, hold=! |
| `SYM/5` | tap=Sticky Layer 1, hold=Layer 5 |
| `CPSW` | tap=CapsWord, hold=Layer 6 |
| `MO1/2/3/4/7` | momentáneo — activo mientras se mantiene |
| `MO7` | hold MO2 + hold MO7 (izq-interno) → Apps |
| `TOG1` | toggle Layer 1 (lock/unlock sin mantener) |
| `[held]` | tecla mantenida para activar la capa |
| `WJ←/→` | word jump (Ctrl+←/→) |
| `SEL←/↓/→` | selección de texto (Shift+flecha) |
