local palette = require('dynamic-theme.palette')
local window = require('dynamic-theme.window')
local create_highlight_groups = require('dynamic-theme.create-highlight-groups')

local M = {}

-- TODO:
--   save command for user
--   write saved values to json file in the root of the directory

M.setup = function(opts)
  opts = opts or {}

  -- create a new table to add palette as the base
  local custom_palette = {}

  -- copy all values from the base palette
  for k, v in pairs(palette) do
    custom_palette[k] = v
  end

  -- override with values with options passed in by the user
  for k, v in pairs(opts) do
    custom_palette[k] = v
  end

  local highlight_groups = create_highlight_groups(custom_palette)

  for group, settings in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end

  -- Create commands for opening and closing the window
  vim.api.nvim_create_user_command('DynamicThemeOpen', function()
    window.open_window {}
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeClose', function()
    window.close_window()
  end, {})
end

return M