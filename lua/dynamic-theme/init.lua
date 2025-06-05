---@class DynamicThemeModule
---@field setup fun(): nil
local M = {}

--- setup function to initialize the plugin
M.setup = function()
  local theme = require 'dynamic-theme.theme'
  local command = require 'dynamic-theme.command'

  -- get the palette values from saved theme or create a new theme file
  local palette = theme.initialize_palette()

  if palette then
    local highlight_groups = theme.create_highlight_groups(palette)
    for group, settings in pairs(highlight_groups) do
      vim.api.nvim_set_hl(0, group, settings)
    end
    command.create()
  else
    vim.notify('Error initializing palette', vim.log.levels.ERROR)
  end
end

return M
