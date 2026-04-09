# Verificación de Bootloader nRF52840

## Método 1: Verificación por software (sin programador)

### Opción A: Chequeo indirecto

Si el bootloader Adafruit está instalado, el chip debería:

1. **Responder a doble-reset** (100ms-500ms entre resets)
2. **Aparecer drive "NICENANO"** al entrar en DFU
3. **Tener archivo INFO_UF2.TXT** con info del bootloader

**Si NO hace nada de esto → No hay bootloader o está corrupto**

### Opción B: Comando DFU por serial

```bash
# Conecta el teclado por USB
# Ejecuta:
./tools/reset_bootloader.sh

# Si sale error o no hace nada:
# → Probablemente no hay bootloader
```

---

## Método 2: Verificación con programador (definitiva)

Necesitas un programador SWD (J-Link, ST-Link, CMSIS-DAP):

### Con nrfjprog (Nordic CLI):

```bash
# Instalar nrfjprog (requiere J-Link)
brew install nrfjprog

# Leer UICR (User Information Configuration)
nrfjprog --readuicr

# Buscar línea: BOOTLOADERADDR
# Si dice: 0xFFFFFFFF → NO HAY BOOTLOADER
# Si dice: 0x000F4000 → Bootloader en 0xF4000 ✅
```

### Con pyOCD (OpenOCD Python):

```bash
# Instalar pyOCD
pip3 install pyocd

# Conectar programador SWD
# Leer registro UICR
pyocd cmd -t nrf52840 "read32 0x10001014"

# Output esperado:
# 0x000f4000 → Bootloader existe ✅
# 0xffffffff → NO HAY BOOTLOADER ❌
```

---

## Método 3: Comparación con lado funcional

### El lado IZQUIERDO funciona:

Si puedes hacer doble-reset en el izquierdo:
- Ese SÍ tiene bootloader instalado
- Podría haber sido comprado de distinto proveedor
- O programado diferente de fábrica

### El lado DERECHO NO funciona:

Posibles razones:
1. **Nunca tuvo bootloader** - Vendido como Pro Micro básico
2. **Bootloader borrado** - Alguien lo programó sin bootloader
3. **Bootloader corrupto** - Parcialmente dañado

---

## Soluciones según el caso:

### Caso A: No hay bootloader

**Necesitas instalarlo con programador SWD:**

```bash
# 1. Descargar bootloader Adafruit
wget https://github.com/adafruit/Adafruit_nRF52_Bootloader/releases/download/0.9.0/nice_nano_bootloader-0.9.0.hex

# 2. Con nrfjprog (J-Link):
nrfjprog --program nice_nano_bootloader-0.9.0.hex --chiperase --verify --reset

# 3. Con pyOCD (CMSIS-DAP, ST-Link):
pyocd flash -t nrf52840 nice_nano_bootloader-0.9.0.hex

# 4. Configurar UICR manualmente:
nrfjprog --memwr 0x10001014 --val 0x000F4000  # BOOTLOADERADDR
nrfjprog --reset
```

### Caso B: Bootloader corrupto

```bash
# Borrar completamente y reinstalar
nrfjprog --eraseall
nrfjprog --program nice_nano_bootloader-0.9.0.hex --verify
nrfjprog --reset
```

---

## Programadores SWD recomendados:

### Opción 1: J-Link EDU Mini (~$20 USD)
- Más confiable
- Soporte oficial Nordic
- Funciona con nrfjprog

### Opción 2: ST-Link V2 Clone (~$5 USD)
- Económico
- Funciona con pyOCD
- Requiere adaptador SWD

### Opción 3: Black Magic Probe (~$25 USD)
- Open source
- Debugging completo
- No requiere software extra

### Opción 4: Raspberry Pi + OpenOCD
- Si tienes RPi disponible
- Usa pines GPIO como SWD
- Gratis (excepto cables)

---

## Conexiones SWD (Programmador → nice!nano):

```
Programador          nice!nano v2
┌────────┐          ┌────────────┐
│ VCC    │─────────→│ VCC        │
│ GND    │─────────→│ GND        │
│ SWDIO  │←────────→│ SWDIO (DIO)│
│ SWCLK  │─────────→│ SWCLK (CLK)│
│ RESET  │─────────→│ RST        │ (opcional)
└────────┘          └────────────┘
```

**Pads en nice!nano:**
- Están en la parte posterior (lado sin componentes)
- Pequeños pads circulares etiquetados: SWDIO, SWCLK
- O pueden estar en el borde junto a RST

---

## Alternativa sin programador:

### Flashear bootloader desde otro nice!nano:

Si tienes 2 nice!nano (izquierdo funciona, derecho no):

**Es POSIBLE pero AVANZADO:**
1. Conectar ambos por SWD (cables directos)
2. Usar el izquierdo como programador (requiere firmware especial)
3. Flashear el derecho desde el izquierdo

**NO recomendado** - Requiere firmware específico y conocimiento avanzado

---

## Recomendación:

**Si el lado izquierdo funciona y el derecho no:**

### Solución rápida (temporal):
- Usa el lado izquierdo con el nuevo firmware
- Deja el derecho con firmware viejo
- Todo funciona, solo sin home row mods en el derecho

### Solución definitiva (recomendada):
1. Comprar programador J-Link EDU Mini ($20)
2. Instalar bootloader Adafruit en el lado derecho
3. Ambos lados con mismo firmware

### Solución económica:
1. Comprar nuevo nice!nano v2 con bootloader (~$25)
2. Reemplazar el lado derecho
3. Guardar el viejo para piezas

---

## ¿Cómo pasó esto?

Posibles escenarios:

1. **nice!nano chino/clon** - Algunos clones no incluyen bootloader
2. **Programado directamente** - Alguien flasheó ZMK sin bootloader
3. **Stock diferente** - Comprado de proveedor distinto que vende sin bootloader
4. **Daño eléctrico** - Spike de voltaje borró UICR

El hecho de que:
- ✅ La aplicación funciona
- ✅ Reset funciona
- ❌ Bootloader no responde

**Confirma casi al 100% que UICR.BOOTLOADERADDR = 0xFFFFFFFF**
(No hay bootloader instalado o la dirección no está configurada)
