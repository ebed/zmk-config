#!/bin/bash

# Script para forzar bootloader por software
# Funciona con nRF52840 / ZMK

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== ZMK Bootloader Reset Tool ===${NC}"
echo ""

# Buscar dispositivo serial
echo "Buscando dispositivo serial..."
DEVICE=$(ls /dev/tty.usbmodem* 2>/dev/null | head -1)

if [ -z "$DEVICE" ]; then
    echo -e "${RED}❌ No se detectó dispositivo serial${NC}"
    echo ""
    echo "Verifica:"
    echo "  1. Conecta el teclado por USB"
    echo "  2. El teclado debe estar funcionando (no en bootloader)"
    echo ""
    echo "Dispositivos disponibles:"
    ls /dev/tty.* 2>/dev/null | grep -v Bluetooth
    exit 1
fi

echo -e "${GREEN}✅ Dispositivo encontrado: $DEVICE${NC}"
echo ""

# Método 1: Comando UF2 DFU
echo -e "${YELLOW}[Método 1] Enviando comando UF2 DFU...${NC}"
echo -ne '\xf0\x0d\xf0\x0d' > "$DEVICE" 2>/dev/null
sleep 2

if ls /Volumes/NICENANO* &>/dev/null || ls /Volumes/NRF52BOOT* &>/dev/null; then
    echo -e "${GREEN}✅ ¡Bootloader activado!${NC}"
    ls -la /Volumes/NICE* /Volumes/NRF* 2>/dev/null
    exit 0
fi

# Método 2: Comando Adafruit DFU
echo -e "${YELLOW}[Método 2] Enviando comando Adafruit DFU...${NC}"
echo -ne '\x57\x01' > "$DEVICE" 2>/dev/null
sleep 2

if ls /Volumes/NICENANO* &>/dev/null || ls /Volumes/NRF52BOOT* &>/dev/null; then
    echo -e "${GREEN}✅ ¡Bootloader activado!${NC}"
    ls -la /Volumes/NICE* /Volumes/NRF* 2>/dev/null
    exit 0
fi

# Método 3: Comando nRF52 DFU
echo -e "${YELLOW}[Método 3] Enviando comando nRF52 DFU...${NC}"
stty -f "$DEVICE" 1200 2>/dev/null
sleep 2

if ls /Volumes/NICENANO* &>/dev/null || ls /Volumes/NRF52BOOT* &>/dev/null; then
    echo -e "${GREEN}✅ ¡Bootloader activado!${NC}"
    ls -la /Volumes/NICE* /Volumes/NRF* 2>/dev/null
    exit 0
fi

# Método 4: Reset a 1200 baud (Arduino style)
echo -e "${YELLOW}[Método 4] Reset a 1200 baud...${NC}"
python3 -c "import serial; s=serial.Serial('$DEVICE', 1200); s.close()" 2>/dev/null
sleep 2

if ls /Volumes/NICENANO* &>/dev/null || ls /Volumes/NRF52BOOT* &>/dev/null; then
    echo -e "${GREEN}✅ ¡Bootloader activado!${NC}"
    ls -la /Volumes/NICE* /Volumes/NRF* 2>/dev/null
    exit 0
fi

echo ""
echo -e "${RED}❌ No se pudo entrar al bootloader por software${NC}"
echo ""
echo "Prueba:"
echo "  1. Método físico: cortocircuito RST-GND mientras conectas USB"
echo "  2. Doble-reset del botón físico"
echo "  3. El bootloader puede no estar instalado en este chip"

