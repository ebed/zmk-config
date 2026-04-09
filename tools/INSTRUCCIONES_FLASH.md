# Cómo entrar en modo bootloader - nice!nano v2

## Método 1: Cortocircuito RST-GND (100% confiable)

### Materiales necesarios:
- Cable/pinza/clip metálico
- O simplemente un destornillador plano pequeño

### Procedimiento:
1. **Conecta el teclado por USB**
2. **Localiza los pines en el nice!nano:**
   ```
   nice!nano v2 (vista superior)
   ┌─────────────────┐
   │  [USB]          │
   │                 │
   │  GND ← Aquí     │
   │  RST ← Y aquí   │
   │  VCC            │
   │  ...            │
   └─────────────────┘
   ```

3. **Haz un puente/cortocircuito entre GND y RST:**
   - Usa un destornillador, pinza o cable
   - Toca ambos pines simultáneamente
   - Mantén contacto por 1-2 segundos
   - Suelta

4. **Debería aparecer el drive "NICENANO"**

### Ubicación exacta de los pines:
- **GND**: Pin en el borde, lado izquierdo (cerca de USB)
- **RST**: Pin justo al lado de GND

## Método 2: Doble-tap RST (si funciona)

1. Conecta por USB
2. Presiona RST rápidamente 2 veces (< 500ms entre clicks)
3. Debe aparecer "NICENANO"

## Método 3: Reset desde software (si ZMK responde)

Si el teclado funciona pero no entra en bootloader:

```bash
# Instala uf2conv (herramienta de Adafruit)
pip3 install adafruit-nrfutil

# Lista dispositivos conectados
ls /dev/tty.usbmodem*

# Envía comando de reset al bootloader
# (reemplaza el dispositivo correcto)
echo -ne '\xf0\x0d\xf0\x0d' > /dev/tty.usbmodemXXXX
```

## Método 4: Mantener RESET mientras conectas

1. Desconecta el USB
2. Mantén presionado el botón RESET
3. Mientras lo mantienes, conecta el USB
4. Suelta RESET después de 2 segundos
5. Debería aparecer "NICENANO"

## ⚠️ Si nada funciona:

El bootloader puede estar corrupto. Necesitarás:
1. Un programador SWD (J-Link, ST-Link)
2. O un Raspberry Pi con cables GPIO
3. Restaurar el bootloader Adafruit nRF52

## Verificación de modo bootloader exitoso:

Cuando entres correctamente verás:
- Drive USB llamado "NICENANO" o "NRF52BOOT"
- Dentro habrá archivos: INFO_UF2.TXT, INDEX.HTM, CURRENT.UF2

## Flashear una vez en bootloader:

```bash
# Copia el firmware
cp ~/Downloads/zmk-firmware/firmware/corne_left\ nice_oled-nice_nano_v2-zmk.uf2 /Volumes/NICENANO/

# O arrastra el .uf2 al drive en Finder
```

El teclado se reiniciará automáticamente después de copiar el archivo.
