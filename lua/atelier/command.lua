local window = require 'atelier.window'
local colorscheme = require 'lua.atelier.colorscheme'
local file = require 'atelier.file'
local page = require 'atelier.page'

--- @class AtelierCommand
--- @field create fun(): nil
local M = {}

--- create plugin commands for executing the user input operations
--- @return nil
M.create = function()
  vim.api.nvim_create_user_command('AtelierOpen', function()
    window.open_window()
  end, {})

  vim.api.nvim_create_user_command('AtelierClose', function()
    window.close_window()
  end, {})

  vim.api.nvim_create_user_command('AtelierSave', function()
    file.save()
  end, {})

  vim.api.nvim_create_user_command('AtelierReset', function()
    colorscheme.reset()
  end, {})

  vim.api.nvim_create_user_command('AtelierColorPage', function()
    page.show_color_page()
  end, {})

  vim.api.nvim_create_user_command('AtelierHelpPage', function()
    page.show_help_page()
  end, {})

  vim.api.nvim_create_user_command('AtelierLibrary', function()
    page.show_theme_page()
  end, {})
end

return M
