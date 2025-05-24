local window = require 'dynamic-theme.window'
local theme = require 'dynamic-theme.theme'
local file = require 'dynamic-theme.file'
local page = require 'dynamic-theme.page'

--- @class DynamicThemeCommand
--- @field create fun(): nil
local M = {}

--- create plugin commands for executing the user input operations
--- @return nil
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
    page.show_color_page()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeHelpPage', function()
    page.show_help_page()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeThemePage', function()
    page.show_theme_page()
  end, {})
end

return M
