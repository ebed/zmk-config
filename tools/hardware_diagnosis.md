# Diagnóstico de Hardware - Bootloader no responde

## Síntoma: Bootloader funcionaba antes, ahora no

Si el bootloader funcionaba y dejó de funcionar → **Problema de hardware**

---

## Pines críticos del bootloader Adafruit:

### Pin de detección DFU (Double-reset button):
```
GPIO usado: P0.18 o P1.00 (depende del board)

Bootloader lee este pin al arrancar:
- Si está LOW (GND) → Entra a DFU mode
- Si está HIGH o flotante → Arranca aplicación normal

PROBLEMA: Si este pin está en cortocircuito a VCC:
→ El bootloader NUNCA entrará a DFU
→ Siempre detectará HIGH
→ Siempre arrancará la aplicación
```

---

## Diagnóstico paso a paso:

### 1. Inspección visual con lupa

Busca en el lado DERECHO del nice!nano:

**A. Puentes de soldadura (bridges):**
- Entre pines adyacentes
- Entre pads del PCB
- Bajo el chip (difícil de ver)

**B. Residuos de flux:**
- Flux puede ser conductor
- Especialmente si es flux "no-clean" barato
- Limpiar con isopropanol 99%

**C. Soldaduras frías "tocando":**
- Soldadura que se expandió y toca otro pad
- Especialmente entre P0.xx pins

**D. Componentes SMD desplazados:**
- Capacitores cerca del chip
- Resistencias de pull-up/down

---

### 2. Medición con multímetro (lado DERECHO desconectado):

**Test A: Continuidad entre pines**

Mide resistencia entre estos pares:
```
VCC ↔ GND    → Debe ser > 10kΩ (no cortocircuito)
P0.18 ↔ VCC  → Debe ser > 100kΩ (alta impedancia)
P0.18 ↔ GND  → Debe ser > 100kΩ (alta impedancia)
P1.00 ↔ VCC  → Debe ser > 100kΩ
P1.00 ↔ GND  → Debe ser > 100kΩ
RST ↔ VCC    → Debe ser > 10kΩ (pull-up débil OK)
RST ↔ GND    → Debe ser > 100kΩ
```

**Si alguna medición da < 10Ω:**
→ **Cortocircuito detectado** en ese par

---

### 3. Comparación con lado IZQUIERDO (funcional)

**Método:**
1. Mide resistencias en el lado IZQUIERDO (que funciona)
2. Anota los valores
3. Mide las mismas en el lado DERECHO
4. Compara

**Ejemplo:**
```
Lado IZQ (funciona):   VCC ↔ GND = 50kΩ
Lado DER (no funciona): VCC ↔ GND = 5Ω  ← ¡CORTOCIRCUITO!
```

---

## Causas comunes de cortocircuito:

### Causa A: Soldadura excesiva
```
PIN 1  PIN 2
  ●━━━━●   ← Puente de soldadura
```
**Solución:** Remover exceso con malla desoldadora

### Causa B: Residuos metálicos
- Virutas de corte de PCB
- Restos de estaño
- Pelo de animal (conduce estática)

**Solución:** Limpiar con aire comprimido + isopropanol

### Causa C: Daño por ESD (Electrostatic Discharge)
```
Síntomas:
- Funcionaba, luego de tocar → dejó de funcionar
- Otros chips en la placa también raros
- Olor a quemado (en casos severos)
```
**Prevención:** Tocar metal aterrizado antes de manipular
**Solución:** Si es daño ESD interno → chip puede estar dañado

### Causa D: Capacitor en corto
```
Capacitores cerca del nRF52840:
- C1, C2 (desacople VCC)
- C3, C4 (desacople analógico)

Si un capacitor está en corto:
→ VCC ↔ GND = baja resistencia
→ Comportamiento errático
```

**Test:** 
```bash
# Con multímetro en continuidad
# (chip DESCONECTADO de USB)

Toca VCC y GND:
- Debe hacer "beep" brevemente luego callar
- Si hace "beep" continuo → capacitor en corto
```

**Solución:** Identificar capacitor dañado y reemplazar

---

## Causa E: Pin RST flotante o con ruido

### Síntoma específico:
- LEDs se congelan al presionar RST ✅
- Pero al soltar, no entra a bootloader ❌

### Causa probable:
**Capacitor de debounce de RST dañado o faltante**

```
Circuito RST típico:

VCC ──┬─── 10kΩ ──┬─── RST pin
      │           │
      └─ 100nF ───┴─── GND
          (C_rst)
```

**Si C_rst (capacitor de 100nF) está:**
- Abierto → Ruido en RST, resets erráticos
- En corto → RST permanece en GND, no arranca

**Test:**
```bash
# Con osciloscopio (ideal) o multímetro:
1. Conecta USB
2. Toca pin RST con sonda
3. Debe medir: 3.3V estable
4. Haz cortocircuito RST-GND
5. Suelta
6. RST debe subir a 3.3V en < 10ms
```

**Si tarda > 100ms en subir:**
→ Capacitor de debounce demasiado grande o RST con ruido

---

## Herramientas de diagnóstico avanzado:

### 1. Osciloscopio (si tienes acceso):

**Prueba RST durante double-tap:**
```
Canal 1: Pin RST
Canal 2: Pin VCC (referencia)

Trigger: Flanco bajada en RST

Expected:
RST: ─┐     ┌─┐     ┌──
      └─────┘ └─────┘
      |<250ms>|
      Reset 1  Reset 2
```

Si ves:
- Rebotes excesivos → Problema de capacitor
- No vuelve a HIGH → Problema de pull-up
- Ruido → Problema de GND o alimentación

### 2. Analizador lógico (más barato):

```bash
# Con Saleae Logic o similar
# Conecta:
# - CH0: RST
# - CH1: P0.18 (pin DFU detect)
# - CH2: TX (serial debug)

# Captura durante reset:
# Deberías ver:
# RST: pulsos de reset
# P0.18: estado durante arranque
# TX: mensajes del bootloader
```

---

## Plan de acción recomendado:

### Paso 1: Limpieza profunda
```bash
1. Desconectar todo
2. Sumergir placa en isopropanol 99% (5 minutos)
3. Cepillar suavemente con cepillo de dientes
4. Secar completamente (aire comprimido)
5. Dejar secar 30 minutos
6. Probar de nuevo
```

Esto elimina:
- Flux conductor
- Residuos metálicos
- Humedad

### Paso 2: Inspección con lupa (x10 o más)
```
Buscar:
- Puentes de soldadura entre pines
- Componentes SMD desplazados
- Soldaduras frías tocando otros pads
- Pistas dañadas en el PCB
```

### Paso 3: Test de resistencias
```bash
# Con multímetro en modo resistencia (Ω)
# Chip DESCONECTADO de USB

Medir y anotar:
1. VCC ↔ GND = _______Ω  (esperado: > 10kΩ)
2. RST ↔ VCC = _______Ω  (esperado: 10-100kΩ, pull-up)
3. RST ↔ GND = _______Ω  (esperado: > 100kΩ)
4. P0.02 ↔ GND = _______Ω (esperado: > 100kΩ)
5. P0.03 ↔ GND = _______Ω (esperado: > 100kΩ)

Comparar con lado IZQUIERDO (funcional)
```

### Paso 4: Test de arranque limpio
```bash
1. Desconecta TODO del nice!nano derecho:
   - Quita matriz de teclas
   - Quita OLED
   - Quita batería
   - Solo nice!nano + USB

2. Intenta double-reset de nuevo

Si funciona → Problema en componente conectado
Si NO funciona → Problema en el nice!nano mismo
```

### Paso 5: Reflash forzado (último recurso)
```bash
# Si tienes programador SWD:

1. Borrar completamente el chip:
   nrfjprog --eraseall

2. Reinstalar bootloader:
   nrfjprog --program bootloader.hex

3. Configurar UICR:
   nrfjprog --memwr 0x10001014 --val 0x000F4000

4. Reset:
   nrfjprog --reset
```

---

## Probabilidades por síntoma:

Tu caso específico:
- ✅ Funcionaba antes
- ✅ Reset funciona (LEDs se congelan)
- ✅ Aplicación funciona normal
- ❌ NO entra a bootloader
- ❌ OLED izquierdo dejó de funcionar también

**Diagnóstico más probable (80%):**
```
Cortocircuito o componente dañado que:
1. Bloquea el pin de detección DFU (P0.18)
2. Causa problemas en I2C (OLED no funciona)
3. Todo lo demás funciona porque no afecta operación normal
```

**Pines a revisar PRIMERO:**
- P0.18 o P1.00 (DFU detect)
- P0.02 (SDA - I2C OLED)
- P0.03 (SCL - I2C OLED)
- VCC/GND alrededor del chip

---

## Red flags (señales de alerta):

🚩 **Si mides VCC ↔ GND < 1kΩ:**
→ Cortocircuito severo, chip puede estar dañado

🚩 **Si RST no sube a 3.3V después de soltar:**
→ Pin RST dañado o pull-up roto

🚩 **Si múltiples funciones dejaron de trabajar juntas:**
→ Daño por ESD o spike de voltaje

🚩 **Si huele a quemado:**
→ Componente quemado, chip puede estar muerto

---

## ¿Cuándo reemplazar el chip?

Considera reemplazar el nice!nano derecho si:

1. ✅ Hiciste limpieza profunda → No funciona
2. ✅ No encuentras cortocircuitos obvios
3. ✅ Resistencias medidas son normales
4. ✅ Aislaste el chip (sin OLED, sin matriz) → Sigue sin funcionar

**En ese caso:**
- Probablemente daño interno al chip
- No vale la pena debugging avanzado
- Más barato comprar nuevo nice!nano (~$25)

---

## TIP: Prevención de ESD

Para evitar que vuelva a pasar:

```
Antes de tocar la placa:
1. Toca una superficie metálica aterrizada
2. Usa pulsera antiestática (ideal)
3. Trabaja sobre mat antiestático
4. Evita ropa sintética (genera estática)
5. Humedad relativa > 40% ayuda
```
