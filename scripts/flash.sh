#!/usr/bin/env bash
# Flashea una mitad del Corne: descarga el firmware del último run verde de CI
# (o del run indicado) y lo copia al volumen NICENANO cuando aparece.
#
# Uso:
#   scripts/flash.sh left            # última build de main
#   scripts/flash.sh right 12345678  # run específico
#
# El bootloader monta ambas mitades con el mismo nombre (NICENANO, viene
# compilado en el bootloader Adafruit nRF52) — este script elimina la
# ambigüedad: tú declaras el lado y él elige el .uf2 correcto.
set -euo pipefail

SIDE="${1:?uso: flash.sh left|right [run_id]}"
case "$SIDE" in
  left|right) ;;
  *) echo "lado inválido: '$SIDE' (usa left o right)" >&2; exit 1 ;;
esac

REPO="ebed/zmk-config"
RUN="${2:-}"
VOLUME="/Volumes/NICENANO"

if [ -z "$RUN" ]; then
  RUN=$(gh run list --repo "$REPO" --branch main --status success --limit 1 \
        --json databaseId -q '.[0].databaseId')
  [ -n "$RUN" ] || { echo "no encontré un run verde en $REPO" >&2; exit 1; }
fi

DIR="$(mktemp -d)"
trap 'rm -rf "$DIR"' EXIT

echo "→ Descargando firmware del run $RUN..."
gh run download "$RUN" --repo "$REPO" --dir "$DIR" >/dev/null

UF2=$(find "$DIR" -name "corne_${SIDE}*zmk.uf2" | head -1)
[ -n "$UF2" ] || { echo "no encontré corne_${SIDE}*.uf2 en el run $RUN" >&2; exit 1; }

echo "→ Pon la mitad ${SIDE} en modo bootloader (doble-tap al reset)..."
until [ -d "$VOLUME" ]; do sleep 0.5; done

cp "$UF2" "$VOLUME/"
echo "✅ ${SIDE} flasheada: $(basename "$UF2") (run $RUN)"
