---@class AtelierModule
---@field setup fun(): nil
local M = {}

--- setup function to initialize the plugin
M.setup = function()
  local colorscheme = require 'atelier.colorscheme'
  local command = require 'atelier.command'

  colorscheme.apply()
  command.create()

  vim.keymap.set(
    'n',
    '<leader>at',
    ':AtelierOpen<CR>',
    { desc = 'Opens the window for the plugin' }
  )
end

return M
