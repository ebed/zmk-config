# Layouts — Visual Reference

ASCII art de todas las capas. Para explicaciones, comportamientos y shortcuts ver [README.md](README.md).

---

## Layer 0 — Base (Colemak-DH + HRM)

```
,------------------------------------------.        ,-----------------------------------------.
| ESC  |  Q  |  W  |  F  |  P   |  B      |        |  J   |  L  |  U  |  Y  |  ;  | BSPC  |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| TAB  |GUI/A|ALT/R|CTL/S|SHF/T |  G      |        |  M   |SHF/N|CTL/E|ALT/I|GUI/O|  '    |
|------+-----+-----+-----+------+---------|        |------+-----+-----+-----+-----+-------|
| REPT |  Z  |  X  |  C  |  D   |  V      |        |  K   |  H  |  ,  |  .  |  /  | DEL   |
'------+-----+-----+-----+------+---------'        '------+-----+-----+-----+-----+-------'
             |CW/L6 | MO7 |SPACE|                      |RET/L5| MO1 | MO2|
             '------+-----+-----'                       '------+-----+----'
```

- `ESC`: tap=ESC (plain)
- `REPT`: repite el último key (`&key_repeat`) — meñique izquierdo inferior
- `BSPC`: ⌫ directo — Fn (L4) accesible desde L2 via MO4
- `DEL`: meñique derecho inferior → ⌦ forward delete
- `CW/L6`: tap=CapsWord / hold=Layer 6 (Lang)
- `MO7`: hold=Layer 7 (Apps) — Ctrl viene del HRM en `S`
- `RET/L5`: tap=↵ RET / hold=Layer 5 (Mac)
- Combo `SPC+MO2` (pos 38+41) → Layer 3 (Sys)
- HRM (home row): tap=letra, hold=mod (GUI/ALT/CTL/SHF)

---

## Layer 1 — Sym (hold MO1)

```
,---------------------------------------------.        ,--------------------------------------------.
| REPT |1/!  |2/@   |3/#   |4/$   |5/%        |        |6/^   |7/&  |8/*   |9/(   |0/)   | DEL   |
|------+-----+------+------+------+-----------|        |------+-----+------+------+------+-------|
| TAB  |BSPC |  <   |  >   |  :   |  ?        |        | -/_  | =/+ | \/|  | `/~  |      |       |
|------+-----+------+------+------+-----------|        |------+-----+------+------+------+-------|
|  SK  |     |      |      |      |           |        | [/{  | ]/} |      |      |      | RET   |
'------+-----+------+------+------+-----------'        '------+-----+------+------+------+-------'
             |TOG1  | MO7  | SPACE|                         |     |      |     |
             '------+------+------'                         '-----+------+-----'
```

- `REPT` (`&key_repeat`): repite el último key en cualquier layer
- `1/!` … `0/)`: tap=número, hold=símbolo Shift+número (280ms)
- `SK`: Sticky Shift (tap=1 char, doble=sticky, triple=CapsLock)
- `TOG1` (`&tog 1`): bloquea/desbloquea Layer 1 — hold MO1 (der middle) + tap izq outer
- Izq home row: `BSPC` · `<` · `>` · `:` · `?` — símbolos frecuentes en código
- Der home/bot: tap=base, hold=Shift+base (280ms, tap-preferred) — patrón igual a fila numérica
  - `-/_` tap=`-` hold=`_` · `=/+` tap=`=` hold=`+` · `\/|` tap=`\` hold=`|` · `` `/~ `` tap=`` ` `` hold=`~`
  - `[/{` tap=`[` hold=`{` · `]/}` tap=`]` hold=`}`

---

## Layer 2 — Nav (hold MO2)

```
,--------------------------------------------.        ,---------------------------------------------.
|      |     |⌘⇧←  |⌘⇧→  |     |             |        |     | WJ← | ↑   | WJ→ |HOME | PGUP  |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|      | ⌘A  | ⌘←  |     |     | ⌘→           |        |     | ←   | ↓   | →   |END  | PGDN  |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|MOUSE | ⌘Z  | ⌘⇧Z |CPY/X|     | ⌘V           |        |KT(⇧)|     |     |     |     |       |
'------+-----+-----+-----+------+------------'        '-----+-----+-----+-----+-----+-------'
             | MO3 |TD4* | SK(⇧)|                          |     |     |[hld]|
             '-----+-----+------'                           '-----+-----+-----'
```

- Izquierdo: edición de texto — `⌘←/→`=inicio/fin línea · `⌘⇧←/→`=sel inicio/fin línea · `CPY/X`=copy/cut · `⌘V`=paste
- Mnemonics izq bot row: `⌘Z`=undo (Z-key) · `⌘⇧Z`=redo (X-key) · `CPY/X`=copy/cut (C-key) · `⌘V`=paste (V-key)
- `⌘A`: Select All — A-key (meñique home row izq), tap directo
- `CPY/X`: tap=⌘C copy / hold=⌘X cut (300ms, tap-preferred)
- `MOUSE`: toggle Layer 8 (meñique izq inferior)
- Derecho fila 1: `WJ←/→`=⌥←/→ (word jump) · `HOME`=inicio doc · `PGUP`=página arriba
- Derecho fila 2: `←↓→`=flechas · `END`=fin doc · `PGDN`=página abajo
- `SK(⇧)` (thumb izq inner): sticky shift — tap=siguiente key con ⇧ · doble tap=⇧ lock
- `KT(⇧)` (K-pos der, fila 3 índice): toggle shift — tap=activa/desactiva; para uso con 1 mano
- `MO3` (pulgar izq outer) → Sys layer
- `TD4*` (pulgar izq middle): hold→FnNum momentáneo · doble-tap→toggle FnNum bloqueado

---

## Layer 8 — Mouse (tog 8 desde L2 pos V, índice izq inferior)

```
,--------------------------------------------.        ,---------------------------------------------.
|SCRL↑ |     |     | M↑  |     |              |        |     |     |     |     |     |       |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SCRL↓ |     | M←  | M↓  | M→  |              |        |     |LCLK |MCLK |RCLK | MB4 | MB5   |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|SCRL← |SCRL→|     |     |     |              |        |     |     |     |     |     | EXIT  |
'------+-----+-----+-----+------+------------'        '-----+-----+-----+-----+-----+-------'
             | EXIT|     |      |                           |     |     |     |
             '-----+-----+------'                           '-----+-----+-----'
```

- Activación: `tog 8` (L2 pos V — índice izq inferior, hold MO2 + tap V) — toggle, no hold
- Izquierdo: movimiento ESDF-like (F=M↑, R=M←, S=M↓, T=M→) + scroll col externa
- Derecho clics home row: `LCLK`=N · `MCLK`=E · `RCLK`=I (índice→medio→anular)
- `MB4`/`MB5`: back/forward del browser — anular y meñique derechos
- `EXIT`: tog 8 en pulgar izq outer (L8) o L2 pos V (misma tecla que activó)
- Velocidad global: `MOVE_VAL=2000` (3.3× default) · `SCRL_VAL=20` (2× default)

---

## Layer 3 — Sys (MO2 + MO3)

```
,--------------------------------------------.        ,--------------------------------------------.
|BTCLR |PRV  |PLAY |NXT  | BLE  | USB        |        |BRI- |BRI+ |     |     |BL-TG| RGB-T |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|      | BT0 | BT1 | BT2 |VOL-  |VOL+        |        |RGB+ |     | BL- | BL+ |RGB- | RGB++ |
|------+-----+-----+-----+------+------------|        |-----+-----+-----+-----+-----+-------|
|      | BT3 | BT4 |     |MUTE  |LCK         |        | 🟢  | 🔴  | 🔵  | 🟡  |SOFF |BOOT   |
'------+-----+-----+-----+------+------------'        '-----+-----+-----+-----+-----+-------'
             | GUI |     | SPACE|                           | RET |     |     |
             '-----+-----+------'                           '-----+-----+-----'
```

- `BRI-/BRI+`: brillo de pantalla
- `RGB-T`: toggle RGB underglow
- `BL-TG`: toggle backlight
- `SOFF`: soft-off (deep sleep) — right pinky col, bottom row (difícil de presionar accidentalmente)
- `BOOT`: modo bootloader para flashear — right extra col, bottom row (la posición más difícil)

---

## Layer 4 — FnNum (hold MO2+TD4 · o doble-tap TD4 para bloquear)

```
,--------------------------------------------.        ,--------------------------------------------.
|  F1  |  F2 |  F3 |  F4 |  F5  |  F6        |        |  ⌫   |  7  |  8  |  9  |  -  |   *   |
|------+-----+-----+-----+------+------------|        |------+-----+-----+-----+-----+-------|
|  F7  |  F8 |  F9 | F10 |  F11 |  F12       |        |  =   |  4  |  5  |  6  |  +  |   /   |
|------+-----+-----+-----+------+------------|        |------+-----+-----+-----+-----+-------|
|      |     |     |     |      |            |        |  ⏎   |  1  |  2  |  3  |  0  |   .   |
'------+-----+-----+-----+------+------------'        '------+-----+-----+-----+-----+-------'
             |TOG-L|[hld]|      |                           |      |     |[hld]|
             '-----+-----+------'                           '------+-----+-----'
```

- Izq fila 1: F1–F6 · Izq fila 2: F7–F12
- Numpad der col 2-4: `7/4/1`, `8/5/2`, `9/6/3` (índice→meñique espeja numpad estándar)
- Numpad der col 5-6: `-/+/0`, `*/⁄/.` (operadores + 0 en pinky)
- Col 1 der: `⌫`=backspace · `=` · `⏎`=enter
- `TOG-L` (thumb izq outer): salir del modo bloqueado
- `[hld]` = TD4 (izq middle) + MO2 (der outer) — ambos mantenidos para activar la capa
- **Modo lock**: doble-tap rápido en TD4 desde L2 → FnNum queda activa sin sostener

---

## Layer 5 — Mac (hold RET/L5)

```
,----------------------------------------------.        ,--------------------------------------------.
|DSK1 |DSK2 |DSK3  |DSK4  |DSK5  | HDE        |        |WIN← |WIN→ |WIN↑  |WIN↓  |MAX   | RST   |
|-----+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
| FQ  |SS📋  |SS⌘4  | UND  | RED  |MCrl        |        | BCK |CTR  |      |      | FWD  | EML   |
|-----+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
|     |DSK← |DSK→  |Exposé| MW←  | MW→        |        | USR |DISP→|      |      |      | PWD   |
'-----+-----+------+------+------+------------'        '-----+-----+------+------+------+-------'
             |      | GUI  | SPACE|                         |[held]|      |      |
             '------+------+------'                         '------+------+------'
```

- Izquierdo: escritorios (DSK1-5), hide others, screenshots, undo/redo, Mission Control
- Derecho: Rectangle (WIN←→↑↓ MAX RST), browser nav (BCK/FWD), display switch (DISP←/→)
- `UND`=⌘Z, `RED`=⌘⇧Z, `BCK`=⌘[, `FWD`=⌘], `FQ`=Force Quit, `MCrl`=Mission Control
- `DISP→`=⌥⌘⇧→ (mover ventana al siguiente display) — configurar en Rectangle Preferences → Shortcuts
- `USR`/`EML`/`PWD`: triggers → Hammerspoon recupera de macOS Keychain (`zmk-keyboard` service)
  - Setup: `security add-generic-password -s "zmk-keyboard" -a "username" -w "VALUE"`
  - Ídem para `email` y `password` — cada Mac configura sus propios valores

---

## Layer 6 — Lang (hold CPSW)

```
,---------------------------------------------.        ,--------------------------------------------.
|      |     |      |      |      |            |        |     |     |  ú   |      |      |       |
|------+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
|      |  ´  |  ~   |  ¨   |  ¿   |  ¡         |        |  á  |  ñ  |  é   |  í   |  ó   |       |
|------+-----+------+------+------+------------|        |-----+-----+------+------+------+-------|
|      |     |      |      |      |            |        |     |     |      |      |      |       |
'------+-----+------+------+------+------------'        '-----+-----+------+------+------+-------'
             |[held]|      |      |                         |      |      |      |
             '------+------+------'                         '------+------+------'
```

- Izquierdo home row: dead keys (`´`=⌥E, `~`=⌥N, `¨`=⌥U) + `¿` y `¡` directos
- Derecho home row: vocales directas (`á`=M-pos, `ñ`=N-pos, `é`=E-pos, `í`=I-pos, `ó`=O-pos)
- Derecho top row: `ú`=U-pos
- `´` = dead acute (⌥E) → vocal → á/é/í/ó/ú (para mayúsculas vía HRM+vocal)
- `~` = dead tilde (⌥N) → n → ñ (dead key conservado en izquierdo)
- `¨` = dead umlaut (⌥U) → u → ü

---

## Layer 7 — Apps (hold MO7)

```
,--------------------------------------------.        ,--------------------------------------------.
|⌘Q   |WTAB |WCLS |WSPL-V|WSPL-H|            |        | WEZ | SLK | ZOM | CHR |CYCL |  ·    |
|-----+-----+-----+------+------+------------|        |-----+-----+-----+-----+-----+-------|
|⌃TAB |ZMUT |ZVID |ZSHR  |ZLVE  |            |        |HELP | CLU |  ·  |  ·  |  ·  |  ·    |
|-----+-----+-----+------+------+------------|        |-----+-----+-----+-----+-----+-------|
|⌃⇧Tab|CLNEW|SMEN |SCOD  |SJMP  |            |        |  ·  |  ·  |  ·  |  ·  |  ·  |  ·    |
'-----+-----+-----+------+------+------------'        '-----+-----+-----+-----+-----+-------'
             |CW/L6|[held]|      |                         | ⌘↩  | MO1 | MO2|
             '-----+------+------'                         '------+-----+----'
```

- Activación: hold `MO7` (izq-medio, sin tap) desde cualquier layer — single key, sin combo
- Izq extra col: `⌘Q` (cerrar app), `⌃Tab` (siguiente tab en app activa), `⌃⇧Tab` (tab anterior)
- Izq top row: WezTerm (Q-P), B vacío
- Izq home row: Zoom completo en A-T (mute/video/share/leave), G vacío
- Izq bot row: Claude (Z) + Slack (X=menciones, C=code, D=jump)
- Der fila superior: focus-or-launch vía Hammerspoon (`⌥⌘⇧` + letra)
- Der resto: `·` transparente — cae al L0 Colemak-DH base (escribe las letras normales)
- Der thumb inner: `⌘↩` — ejecuta/confirma en apps (Terminal, Alfred, etc.)

| Key | Shortcut | App | Acción |
|-----|----------|-----|--------|
| `ESC` — ⌘Q | `⌘+Q` | activa | Cerrar aplicación |
| `TAB` — ⌃Tab | `⌃+Tab` | macOS | Siguiente tab (en app activa) |
| `CTRL` — ⌃⇧Tab | `⌃+⇧+Tab` | macOS | Tab anterior (en app activa) |
| thumb-⌘↩ | `⌘+↩` | — | Ejecutar/confirmar (thumb der inner) |
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
| `N` — CLU | `⌥⌘⇧+N` | Hammerspoon | Focus-or-launch Claude Desktop |
| `J` — WEZ | `⌥⌘⇧+W` | Hammerspoon | Focus-or-launch WezTerm |
| `L` — SLK | `⌥⌘⇧+S` | Hammerspoon | Focus-or-launch Slack |
| `U` — ZOM | `⌥⌘⇧+Z` | Hammerspoon | Focus-or-launch Zoom |
| `Y` — CHR | `⌥⌘⇧+C` | Hammerspoon | Focus-or-launch Chrome |
| `;` — CYCL | `⌘+\`` | macOS | Ciclar ventanas de la app activa |

---

## Layer 9 — Tmux (hold TAB)

Cada tecla envía el prefix `Ctrl+A` seguido de la tecla (behavior `&tmx`, ver `~/.tmux.conf`).

```
,-----------------------------------------.        ,-----------------------------------------.
|  [   |  1  |  2  |  3  |  4  |  5       |        |  z  |  ;  |  k  |  |  |  -  |         |
| copy |   ventanas 1-5                   |        |zoom |last |pane↑|spl-h|spl-v|         |
|------+-----+-----+-----+-----+-----------|        |-----+-----+-----+-----+-----+---------|
|[hld] |  c  |  p  |  n  |  $  |  s       |        |  ]  |  h  |  j  |  l  |     |         |
|      | new |prev |next |ren-S|tree      |        |paste|pane←|pane↓|pane→|     |         |
|------+-----+-----+-----+-----+-----------|        |-----+-----+-----+-----+-----+---------|
|  ,   |  x  |  &  |  d  |  r  | C-l      |        |     |  H  |  J  |  K  |  L  |         |
| ren-W|kill-|kill-|det. |reld |last-sess |        |     |       resize 5            |
'------+-----+-----+-----+-----+-----------'        '-----+-----+-----+-----+-----+---------'
```

- Derecha: panes con la geometría de Nav (h←  j↓  l→, k↑ arriba); Shift+hjkl = resize
- Izquierda: ventanas 1-5 (`base-index 1`), c/p/n, sesiones (`$`, `s`, `C-l`), kill/detach en la fila baja
- Activación: hold `TAB` (`&lt 9 TAB`); tap sigue siendo TAB

---

## Leyenda

| Símbolo | Significado |
|---------|-------------|
| `GUI/A` | tap=A, hold=Cmd |
| `ALT/R` | tap=R, hold=Alt |
| `CTL/S` | tap=S, hold=Ctrl |
| `SHF/T` | tap=T, hold=Shift |
| `1/!` | tap=1, hold=! |
| `BSPC` | ⌫ directo |
| `REPT` | repite el último key (`&key_repeat`) |
| `CW/L6` | tap=CapsWord, hold=Layer 6 (Lang) |
| `MO7` | hold=Layer 7 (Apps) — sin tap |
| `RET/L5` | tap=↵ RET, hold=Layer 5 (Mac) |
| `MO1/2/4` | momentáneo — activo mientras se mantiene |
| `TOG1` | toggle Layer 1 (lock/unlock sin mantener) |
| `[held]` | tecla mantenida para activar la capa |
| `SPC+MO2` | combo (left inner + right outer) → Layer 3 (Sys) |
| `WJ←/→` | word jump (⌥←/→) |
| `SK(⇧)` | sticky shift — tap=1 key con ⇧, doble tap=⇧ lock |
| `KT(⇧)` | key toggle shift — tap=activa, tap=desactiva |
