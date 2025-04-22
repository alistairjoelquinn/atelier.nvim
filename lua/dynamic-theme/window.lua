local file = require 'dynamic-theme.file'

local M = {}

---@class WindowData
---@field win number
---@field buf number

---@type WindowData
local window_data = {
  win = -1,
  buf = -1,
}

-- Create keymap for navigation and saving
local create_keymaps = function()
  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    { noremap = true, silent = true }
  )
end

local function populate_buffer()
  local lines = {
    'Dynamic Theme Color Editor',
    '--------------------------',
    '',
    "Edit hex color values below. Press 's' to save changes, 'q' to quit.",
    '',
  }

  local current_palette = file.read()

  for name, hex in pairs(current_palette) do
    local display_name = name:gsub('_', ' ')
    local input_line = string.format('  %s: %s', display_name, hex)
    table.insert(lines, input_line)
  end

  vim.api.nvim_buf_set_lines(window_data.buf, 0, -1, false, lines)
end

local create_window = function()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local config = {
    style = 'minimal',
    border = 'rounded',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
  }

  -- we always try and reuse the buffer from the previous open window, though
  -- always create a new window as the old window can't be reused
  if not vim.api.nvim_buf_is_valid(window_data.buf) then
    window_data.buf = vim.api.nvim_create_buf(false, true)
  end

  populate_buffer()

  window_data.win = vim.api.nvim_open_win(window_data.buf, true, config)
end

-- Save changes from input fields
M.save_changes = function()
  -- TODO: read out the updated values in the buffer before saving and then calling update palette
  -- which will re apply the updated values as a new theme
  vim.notify('Theme colors saved successfully!', vim.log.levels.INFO)
end

M.open_window = function()
  if not vim.api.nvim_win_is_valid(window_data.win) then
    create_window()
    create_keymaps()
  end
end

M.close_window = function()
  if vim.api.nvim_win_is_valid(window_data.win) then
    vim.api.nvim_win_close(window_data.win, false)
  end
end

return M
