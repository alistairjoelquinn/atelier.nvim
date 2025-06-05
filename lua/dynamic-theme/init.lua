---@class DynamicThemeModule
---@field setup fun(): nil
local M = {}

--- setup function to initialize the plugin
M.setup = function()
  local theme = require 'dynamic-theme.theme'
  local command = require 'dynamic-theme.command'

  -- get the palette values from saved theme or create a new theme file
  local loaded_palette = theme.initialize_palette()

  if not loaded_palette then
    vim.notify('Error initializing palette', vim.log.levels.ERROR)
    return
  end

  local highlight_groups = theme.create_highlight_groups(loaded_palette)

  for group, settings in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end

  command.create()
end

return M
