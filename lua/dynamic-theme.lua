local palette = require 'palette'
local create_window = require 'create-window'
local create_highlight_groups = require 'create-highlight-groups'

local M = {}
local window_data = nil

M.open_window = function(opts)
  if window_data and vim.api.nvim_win_is_valid(window_data.win) then
    vim.api.nvim_set_current_win(window_data.win)
    return
  end

  window_data = create_window(opts)

  -- Map 'q' to close the window
  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    { noremap = true, silent = true }
  )
end

M.close_window = function()
  if window_data and vim.api.nvim_win_is_valid(window_data.win) then
    vim.api.nvim_win_close(window_data.win, true)
    window_data = nil
  end
end

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
    M.open_window()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeClose', function()
    M.close_window()
  end, {})
end

return M
