-- =============================================================================
-- STARTUP MODULE — Tabs iniciales al arrancar WezTerm
-- =============================================================================
-- Se dispara una vez al iniciar WezTerm (no al abrir ventanas adicionales).
-- Abre 3 tabs con roles distintos; splits dentro de cada tab los hace WezTerm.
-- Regla: no mezclar splits de WezTerm y tmux en la misma tab.

local wezterm = require('wezterm')
local mux     = wezterm.mux
local M       = {}

function M.apply_to_config(_config)
  wezterm.on('gui-startup', function(cmd)
    local shell = os.getenv('SHELL') or 'zsh'

    -- Tab 1 — tmux local: sesiones que sobreviven al reinicio de WezTerm
    -- Ruta absoluta: el PATH en gui-startup no incluye /opt/homebrew/bin
    local _tab1, _pane1, window = mux.spawn_window(cmd or {
      args = { '/opt/homebrew/bin/tmux', 'new-session', '-A', '-s', 'local' },
    })

    -- Tab 2 — Remote: shell limpio para `ssh host` → `tmux attach`
    local tab2 = window:spawn_tab({ args = { shell, '-l' } })

    -- Tab 3 — Quick shell: comandos one-off, sin overhead de tmux
    local tab3 = window:spawn_tab({ args = { shell, '-l' } })

    -- Volver al foco en tab 1
    _tab1:activate()

    -- Silenciar warnings de variables no usadas (Lua)
    _ = tab2
    _ = tab3
  end)
end

return M
