# Corne Keyboard ZMK Keymap

Este repositorio contiene la configuración personalizada del teclado Corne usando [ZMK Firmware](https://zmk.dev/).

---

## 📦 Resumen

- **Modelo:** Corne (CRKBD)
- **Firmware:** ZMK
- **Capas definidas:** Base, Números/Símbolos, Navegación/Mouse, Lower/BT/RGB, Funciones
- **Soporte RGB y Backlight**
- **Soporte para Bluetooth y USB**

---

## 🎛️ Distribución de Capas (ASCII Art)

### Layer 0: Base

```
,------------------------------------.           ,---------------------------------------.
| ESC |  Q  |  W  |  F  |  P  |  B  |               |  J  |  L  |  U  |  Y  |  ;  | BSPC |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
| TAB |  A  |  R  |  S  |  T  |  G  |               |  M  |  N  |  E  |  I  |  O  |  '   |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
|CTRL |  Z  |  X  |  C  |  D  |  V  |               |  K  |  H  |  ,  |  .  |  /  | RET  |
'-----+-----+-----+-----+-----+-----'               '-----+-----+-----+-----+-----+------'
      | SHFT| GUI |SPACE|                               |MO2 |MO1 |RALT|
      '-----+-----+-----'                               '----+-----+----'
```

---

### Layer 1: Números/Símbolos

```
,-----------------------------------.               ,-------------------------------------.
|     |  1  |  2  |  3  |  4  |  5  |               |  6  |  7  |  8  |  9  |  0  | DEL  |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
| TAB |     |     |     |     |     |               |  -  |  =  |     |     |  \  |  `   |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
|CTRL |     |     |     |     |     |               |  [  |  ]  |     |     |     | RET  |
'-----+-----+-----+-----+-----+-----'               '-----+-----+-----+-----+-----+------'
      | SHFT| GUI |SPACE|                               |MO3 |     |RALT|
      '-----+-----+-----'                               '----+-----+----'
```

---

### Layer 2: Navegación/Mouse

```
,----------------------------------.                ,-------------------------------------.
|SCRUP|     | MUP |     |LCLK |     |               |     | UP  |     |     |     | BSPC |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
|SCRDN|MLFT |MDN  |MRGT |MCLK |     |               |LEFT |DOWN |RGHT |     | PGUP |HOME |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
|SCLFT|SCRT |     |     |RCLK |     |               |     |     |     |     |PGDN |END   |
'-----+-----+-----+-----+-----+-----'               '-----+-----+-----+-----+-----+------'
      | SHFT| GUI |SPACE|                               |    |MO4 |RALT|
      '-----+-----+-----'                               '----+-----+----'
```

---

### Layer 3: Lower/BT/RGB

```
,------------------------------------.              ,-------------------------------------.
|BTCLR|     |     |     | BLE | USB |               |     |     |     | BLTG| RGBT|      |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
|SOFF | BT0 | BT1 | BT2 |     |     |               |RGBE |     | BLD | BLI |RGBD | RGBI |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
|     | BT3 | BT4 | BT5 |     |     |               |RGB1 |RGB2 |RGB3 |RGB4 |     |      |
'-----+-----+-----+-----+-----+-----'               '-----+-----+-----+-----+-----+------'
      | GUI |     |SPACE|                               |RET |     |RALT|
      '-----+-----+-----'                               '----+-----+----'
```

---

### Layer 4: Funciones

```
,------------------------------------.              ,------------------------------------.
| F1  | F2  | F3  | F4  | F5  | F6  |               | F7  | F8  | F9  | F10 | F11 | F12  |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
|     |     |     |     |     |     |               |     |     |     |     |     |      |
|-----+-----+-----+-----+-----+-----|               |-----+-----+-----+-----+-----+------|
|CTRL |     |     |     |     |     |               |     |     |     |     |     |      |
'-----+-----+-----+-----+-----+-----'               '-----+-----+-----+-----+-----+------'
      | SHFT|     |     |                               |    |     |    |
      '-----+-----+-----'                               '----+-----+----'
```

---

## 💡 Características Avanzadas

- **RGB y Backlight:** Control total desde el teclado.
- **Bluetooth:** Cambio rápido entre dispositivos.
- **Soporte Mouse:** Navegación y clicks desde el teclado.

---

## 🛠️ Personalización

Puedes modificar las capas editando el archivo `corne.keymap` y recompilando el firmware con ZMK.

---

## 📄 Licencia

MIT License. Consulta el archivo fuente para detalles.

