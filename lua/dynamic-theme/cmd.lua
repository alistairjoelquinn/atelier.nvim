local window = require 'dynamic-theme.window'
local file = require 'dynamic-theme.file'

local M = {}

M.create_commands = function()
  -- create commands for opening and closing the window
  vim.api.nvim_create_user_command('DynamicThemeOpen', function()
    window.open_window()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeClose', function()
    window.close_window()
  end, {})

  -- Add command to save theme
  vim.api.nvim_create_user_command('DynamicThemeSave', function()
    file.save()
  end, {})
end

return M
