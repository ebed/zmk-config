# Herramientas de Flasheo ZMK

Esta carpeta contiene scripts y guías para flashear firmware ZMK en tu Corne con nice!nano v2.

## 📁 Archivos

- `reset_bootloader.sh` - Script bash para forzar bootloader (no requiere dependencias)
- `reset_bootloader.py` - Script Python alternativo (requiere pyserial)
- `INSTRUCCIONES_FLASH.md` - Guía completa de métodos de flasheo
- `nice_nano_pinout.txt` - Diagrama visual del pinout del nice!nano

## 🚀 Uso rápido

### Método 1: Reset por software (más simple)

```bash
# 1. Conecta el teclado por USB
# 2. Ejecuta el script:
./tools/reset_bootloader.sh

# 3. Si aparece NICENANO, copia el firmware:
cp ~/Downloads/corne_left-nice_nano_v2-zmk.uf2 /Volumes/NICENANO/
```

### Método 2: Cortocircuito RST-GND

Si el método por software no funciona:

```bash
# 1. Desconecta el USB
# 2. Haz cortocircuito entre pines RST y GND (ver nice_nano_pinout.txt)
# 3. SIN SOLTAR, conecta el USB
# 4. Mantén el cortocircuito 5 segundos
# 5. Suelta
# 6. Debería aparecer /Volumes/NICENANO
```

Ver diagrama detallado en `nice_nano_pinout.txt`

## 📋 Firmwares disponibles

Los firmwares compilados están en GitHub Actions:
- `corne_left nice_oled-nice_nano_v2-zmk.uf2` - Lado izquierdo
- `corne_right nice_oled-nice_nano_v2-zmk.uf2` - Lado derecho
- `settings_reset-nice_nano_v2-zmk.uf2` - Reset de configuración

Descárgalos desde: https://github.com/ebed/zmk-config/actions

## ⚙️ Configuración actual

El keymap incluye:
- ✅ **Home row mods** (A/R/S/T = GUI/Alt/Ctrl/Shift en mano izquierda)
- ✅ Layout Colemak-DH
- ✅ 5 capas: Base, Números/Símbolos, Navegación/Mouse, BT/RGB, Funciones
- ✅ Soporte OLED nice!nano
- ✅ RGB underglow
- ✅ Mouse emulation

## 🔧 Troubleshooting

### El bootloader no se activa

1. Prueba el script: `./tools/reset_bootloader.sh`
2. Si falla, usa cortocircuito físico (ver instrucciones)
3. Si nada funciona, el bootloader puede no estar instalado

### Error "No se detectó dispositivo serial"

- Verifica que el teclado esté conectado y funcionando
- Revisa `/dev/tty.usbmodem*`
- El teclado debe estar en modo normal (NO en bootloader)

### Script Python no funciona

Instala dependencias:
```bash
brew install pipx
pipx install pyserial
```

O usa el script bash que no requiere dependencias.

## 📖 Documentación completa

- **Instrucciones de flasheo**: `INSTRUCCIONES_FLASH.md`
- **Pinout del chip**: `nice_nano_pinout.txt`
- **ZMK Documentation**: https://zmk.dev/docs

## 🆘 Soporte

Si tienes problemas:
1. Lee `INSTRUCCIONES_FLASH.md` - cubre 4 métodos diferentes
2. Revisa el pinout en `nice_nano_pinout.txt`
3. Verifica que el bootloader Adafruit esté instalado en tu nice!nano
