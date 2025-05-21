---@class DynamicThemeModule
local M = {}

-- TODO:
--   command to save changes by user
--   write saved values to json file in the root of the directory
--   OPTIONS
--      allow persisting multiple themes which can be toggled
--      allow to reset back to the default them from when first loading the plugin

M.setup = function()
  local theme = require 'dynamic-theme.theme'
  local command = require 'dynamic-theme.command'

  -- get the palette values from saved theme or create a new theme file
  local palette = theme.initialise_palette()

  local highlight_groups = theme.create_highlight_groups(palette)

  for group, settings in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end

  command.create()
end

return M
