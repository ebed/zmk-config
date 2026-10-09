#!/bin/bash

# =============================================================================
# CLAUDE CODE HOOKS - Notificaciones Automáticas
# =============================================================================
#
# Scripts que se ejecutan cuando Claude Code completa tareas
# Para usar: configura estos scripts en tu settings.json de Claude Code
#
# Author: ralbertomerinocolipe
# Last update: 2026-04-02

# Función para enviar notificación visual (bell)
send_notification() {
    local title="$1"
    local message="$2"
    local duration="${3:-5}"

    # Enviar bell character a wezterm
    echo -ne '\a'

    # Usar osascript para notificación nativa de macOS
    osascript -e "display notification \"$message\" with title \"$title\" sound name \"Glass\""
}

# =============================================================================
# HOOK: Task Started (cuando Claude empieza una tarea)
# =============================================================================
task_started() {
    local task_name="${CLAUDE_TASK_NAME:-Tarea}"

    # Enviar notificación de inicio
    send_notification "Claude Code" "🚀 Iniciando: $task_name" 3

    # Cambiar título del terminal Y marcarlo como persistente
    echo -ne "\033]0;🤖 Claude: $task_name\007"

    # Guardar estado en archivo temporal para que persista entre comandos
    echo "ACTIVE" > /tmp/claude-active-$$
}

# =============================================================================
# HOOK: Task Completed (cuando Claude termina con éxito)
# =============================================================================
task_completed() {
    local task_name="${CLAUDE_TASK_NAME:-Tarea}"
    local duration="${CLAUDE_TASK_DURATION:-?}"

    # Enviar notificación de éxito
    send_notification "Claude Code" "✅ Completado: $task_name (${duration}s)" 8

    # Enviar bell múltiple para que sea más notorio
    echo -ne '\a\a'

    # NO restaurar título - dejar que el usuario vea que necesita atención
    # Cambiar a estado "esperando respuesta"
    echo -ne "\033]0;🤖 Claude: Esperando respuesta\007"

    # Mantener estado activo
    echo "WAITING" > /tmp/claude-active-$$
}

# =============================================================================
# HOOK: Task Failed (cuando Claude encuentra un error)
# =============================================================================
task_failed() {
    local task_name="${CLAUDE_TASK_NAME:-Tarea}"
    local error="${CLAUDE_ERROR:-Error desconocido}"

    # Enviar notificación de error
    send_notification "Claude Code" "❌ Falló: $task_name" 10

    # Enviar bell triple para error
    echo -ne '\a\a\a'

    # Restaurar título del terminal
    echo -ne "\033]0;Terminal\007"
}

# =============================================================================
# HOOK: Tool Called (cuando Claude usa una herramienta)
# =============================================================================
tool_called() {
    local tool_name="${CLAUDE_TOOL_NAME:-Tool}"

    # Solo notificar herramientas importantes
    case "$tool_name" in
        Bash|Edit|Write)
            # Cambiar título del terminal temporalmente
            echo -ne "\033]0;🤖 Claude usando: $tool_name\007"
            ;;
    esac
}

# =============================================================================
# HOOK: Reset (limpiar estado de Claude)
# =============================================================================
reset_claude() {
    # Limpiar archivo de estado
    rm -f /tmp/claude-active-$$

    # Restaurar título del terminal
    echo -ne "\033]0;Terminal\007"

    send_notification "Claude Code" "🔄 Estado limpiado" 2
}

# =============================================================================
# MAIN - Ejecutar el hook apropiado
# =============================================================================

HOOK_TYPE="${1:-task_completed}"

case "$HOOK_TYPE" in
    task_started)
        task_started
        ;;
    task_completed)
        task_completed
        ;;
    task_failed)
        task_failed
        ;;
    tool_called)
        tool_called
        ;;
    reset)
        reset_claude
        ;;
    *)
        echo "Hook desconocido: $HOOK_TYPE"
        exit 1
        ;;
esac
