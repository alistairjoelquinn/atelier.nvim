---@type DynamicThemePalette
local palette = require 'dynamic-theme.palette'
local window = require 'dynamic-theme.window'
---@type fun(colors: DynamicThemePalette): table<string, table>
local create_highlight_groups = require 'dynamic-theme.create-highlight-groups'

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

  -- create a new table to add palette as the base
  ---@type DynamicThemePalette
  local custom_palette = {}

  -- copy all values from the base palette
  for k, v in pairs(palette) do
    custom_palette[k] = v
  end

  -- override with values with options passed in by the user
  for k, v in pairs(opts) do
    custom_palette[k] = v
  end

  ---@type table<string, table>
  local highlight_groups = create_highlight_groups(custom_palette)

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
end

return M
