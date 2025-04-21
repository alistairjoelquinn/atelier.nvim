---@type DynamicThemePalette
local palette = require 'dynamic-theme.palette'
local window = require 'dynamic-theme.window'
local theme = require 'dynamic-theme.theme'

---@class DynamicThemeModule
local M = {}

-- TODO:
--   command to save changes by user
--   write saved values to json file in the root of the directory
--   OPTIONS
--      allow persisting multiple themes which can be toggled
--      allow to reset back to the default them from when first loading the plugin

---@param opts? table Options to override the default palette colors
---@return nil
M.setup = function(opts)
  opts = opts or {}

  print 'initialising theme'
  -- Get the palette values from saved theme or create a new theme file
  local custom_palette = theme.initialise_theme()

  -- If the palette doesn't have all the expected structure, fill in from defaults
  for k, v in pairs(palette) do
    if custom_palette[k] == nil then
      custom_palette[k] = v
    end
  end

  -- override with values with options passed in by the user
  for k, v in pairs(opts) do
    custom_palette[k] = v
  end

  ---@type table<string, table>
  local highlight_groups = theme.create_highlight_groups(custom_palette)

  for group, settings in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end

  -- Create commands for opening and closing the window
  vim.api.nvim_create_user_command('DynamicThemeOpen', function()
    window.open_window()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeClose', function()
    window.close_window()
  end, {})

  -- Add command to save theme
  vim.api.nvim_create_user_command('DynamicThemeSave', function()
    -- TODO: Get the current theme values and save to json file
    local config_path = vim.fn.stdpath 'config'
    local json_path = config_path .. '/dynamic-theme.json'

    -- For now, just save a message that this feature is coming soon
    vim.notify('Theme saving feature coming soon!', vim.log.levels.INFO)
  end, {})
end

return M
