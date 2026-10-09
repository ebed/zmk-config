# Corne ZMK Config

Teclado Corne (CRKBD) split 42 teclas, nice!nano v2, ZMK v0.3.0 + zmk-nice-oled. Colemak-DH con home-row mods. No hay build local: compila GitHub Actions (`.github/workflows/build.yml`, matriz en `build.yaml`).

## Archivos clave

| Archivo | Contenido |
|---------|-----------|
| `config/corne.keymap` | Capas, behaviors (hold-tap, macros, tap-dance), combos |
| `config/corne.conf` | Opciones Kconfig (BT, RGB, OLED, sleep) |
| `config/west.yml` | Versión de ZMK y módulos (pinear revisiones, no usar `main`) |
| `LAYOUTS.md` / `README.md` | Documentación de capas (ASCII art, tablas) |
| `hammerspoon/`, `scripts/` | Popup de capas y atajos macOS (`setup-hammerspoon.sh`) |
| `tmux/tmux.conf` | Config de tmux (prefix `Ctrl+A`) que asume el Layer 9; se instala con `scripts/setup-tmux.sh` |

## Reglas

- Todo cambio en `corne.keymap` (capas, combos, behaviors) **actualiza `LAYOUTS.md` y `README.md` en el mismo commit** (o un `docs:` inmediato). Detalle en esos archivos; leer solo la sección de la capa tocada (`offset`/`limit`).
- Un cambio en `tmux/tmux.conf` (prefix, binds) obliga a revisar el Layer 9 y su doc/popup.
- Mantener 42 bindings por capa y el índice de capas coherente con los `MO/TOG/LT` que las referencian; al insertar o reordenar una capa, revisar todas las referencias.
- Validar con CI antes de dar algo por hecho: `git push` y revisar el run (`gh run list --limit 3`, `gh run view --log-failed`). No declarar "funciona" solo por compilar: el comportamiento se prueba en el teclado.
- Cambios de Kconfig/west: uno por commit, para poder bisecar si el firmware deja de arrancar.
- Dependencias externas (zmk, nice-oled) siempre con tag/commit fijo.

## Convenciones

- Respuestas en español; código, nombres de behaviors y commits en inglés.
- Commits convencionales con la capa en el scope: `feat(L2): ...`, `fix(L1): ...`, `docs: ...`, `refactor(L1/L2): ...`.
- Commitear antes de cambios grandes de keymap (rollback fácil con `git revert`).
