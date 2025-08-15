---@class DynamicThemeModule
---@field setup fun(): nil
local M = {}

--- setup function to initialize the plugin
M.setup = function()
  local theme = require 'lua.dynamic-theme.colorscheme'
  local command = require 'dynamic-theme.command'

  theme.apply()
  command.create()

  vim.keymap.set(
    'n',
    '<leader>dt',
    ':DynamicThemeOpen<CR>',
    { desc = 'Opens the window for dynamic theme' }
  )
end

return M
