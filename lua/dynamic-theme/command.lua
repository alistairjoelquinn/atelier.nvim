local window = require 'dynamic-theme.window'
local theme = require 'dynamic-theme.theme'
local file = require 'dynamic-theme.file'

local M = {}

M.create = function()
  vim.api.nvim_create_user_command('DynamicThemeOpen', function()
    window.open_window()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeClose', function()
    window.close_window()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeSave', function()
    file.save()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeReset', function()
    theme.reset()
  end, {})
end

return M
