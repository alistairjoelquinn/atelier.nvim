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

  vim.api.nvim_create_user_command('DynamicThemeColorPage', function()
    window.show_color_page()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeHelpPage', function()
    window.show_help_page()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeThemePage', function()
    window.show_theme_page()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeLoad', function() end, {})

  vim.api.nvim_create_user_command('DynamicThemeRename', function() end, {})
end

return M
