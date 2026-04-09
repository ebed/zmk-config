#!/usr/bin/env python3
"""
Script para forzar bootloader en nRF52840 por diferentes métodos
"""

import serial
import serial.tools.list_ports
import time
import sys
import os

def find_zmk_device():
    """Encuentra el dispositivo ZMK conectado"""
    ports = serial.tools.list_ports.comports()
    for port in ports:
        if 'usbmodem' in port.device.lower():
            return port.device
    return None

def check_bootloader():
    """Verifica si el bootloader está activo"""
    volumes = os.listdir('/Volumes')
    for vol in volumes:
        if 'NICENANO' in vol.upper() or 'NRF52' in vol.upper():
            return True, vol
    return False, None

def method_1200_baud(device):
    """Método 1: Reset a 1200 baud (Arduino bootloader style)"""
    print("🔧 [Método 1] Reset a 1200 baud...")
    try:
        ser = serial.Serial(device, 1200)
        time.sleep(0.5)
        ser.close()
        time.sleep(2)
        return check_bootloader()
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False, None

def method_dfu_command(device):
    """Método 2: Comando DFU binario"""
    print("🔧 [Método 2] Comando DFU...")
    try:
        ser = serial.Serial(device, 115200, timeout=1)
        # Comando UF2 DFU
        ser.write(b'\xf0\x0d\xf0\x0d')
        time.sleep(0.5)
        ser.close()
        time.sleep(2)
        return check_bootloader()
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False, None

def method_adafruit_dfu(device):
    """Método 3: Comando Adafruit DFU"""
    print("🔧 [Método 3] Comando Adafruit DFU...")
    try:
        ser = serial.Serial(device, 115200, timeout=1)
        # Comando Adafruit
        ser.write(b'\x57\x01')
        time.sleep(0.5)
        ser.close()
        time.sleep(2)
        return check_bootloader()
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False, None

def method_dtr_rts_toggle(device):
    """Método 4: Toggle DTR/RTS"""
    print("🔧 [Método 4] Toggle DTR/RTS...")
    try:
        ser = serial.Serial(device, 115200)
        ser.setDTR(False)
        ser.setRTS(False)
        time.sleep(0.1)
        ser.setDTR(True)
        ser.setRTS(True)
        time.sleep(0.1)
        ser.setDTR(False)
        time.sleep(2)
        ser.close()
        time.sleep(2)
        return check_bootloader()
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return False, None

def main():
    print("=" * 60)
    print("      ZMK Bootloader Reset Tool (Python)")
    print("=" * 60)
    print()
    
    # Buscar dispositivo
    print("🔍 Buscando dispositivo ZMK...")
    device = find_zmk_device()
    
    if not device:
        print("❌ No se encontró dispositivo serial")
        print()
        print("Dispositivos disponibles:")
        for port in serial.tools.list_ports.comports():
            print(f"  - {port.device}: {port.description}")
        print()
        print("Conecta el teclado y vuelve a intentar")
        sys.exit(1)
    
    print(f"✅ Dispositivo encontrado: {device}")
    print()
    
    # Intentar todos los métodos
    methods = [
        method_1200_baud,
        method_dfu_command,
        method_adafruit_dfu,
        method_dtr_rts_toggle
    ]
    
    for i, method in enumerate(methods, 1):
        try:
            success, volume = method(device)
            if success:
                print()
                print("=" * 60)
                print(f"✅ ¡Bootloader activado con Método {i}!")
                print(f"📂 Drive montado: /Volumes/{volume}")
                print("=" * 60)
                print()
                print("Ahora puedes copiar el firmware .uf2")
                sys.exit(0)
        except Exception as e:
            print(f"   ❌ Excepción: {e}")
        
        print()
    
    # Si ningún método funcionó
    print("=" * 60)
    print("❌ No se pudo entrar al bootloader por software")
    print("=" * 60)
    print()
    print("Opciones restantes:")
    print("  1. Cortocircuito RST-GND mientras conectas USB")
    print("  2. Doble-reset del botón físico")
    print("  3. El bootloader puede no estar instalado")

if __name__ == "__main__":
    main()
