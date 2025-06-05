---@class DynamicThemeModule
---@field setup fun(): nil
local M = {}

--- setup function to initialize the plugin
M.setup = function()
  local theme = require 'dynamic-theme.theme'
  local command = require 'dynamic-theme.command'

  theme.apply()
  command.create()
end

return M
