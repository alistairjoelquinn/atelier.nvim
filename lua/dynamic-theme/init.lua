---@class DynamicThemeModule
---@field setup fun(): nil
local M = {}

--- setup function to initialize the plugin
M.setup = function()
  local colorscheme = require 'lua.dynamic-theme.colorscheme'
  local command = require 'dynamic-theme.command'

  colorscheme.apply()
  command.create()

  vim.keymap.set(
    'n',
    '<leader>dt',
    ':DynamicThemeOpen<CR>',
    { desc = 'Opens the window for the plugin' }
  )
end

return M
