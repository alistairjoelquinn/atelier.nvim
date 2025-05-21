local file = require 'dynamic-theme.file'
local utils = require 'dynamic-theme.utils'

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

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    's',
    ':DynamicThemeSave<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'r',
    ':DynamicThemeReset<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    '?',
    ':DynamicThemeHelp<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'l',
    ':DynamicThemeLoad<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'n',
    ':DynamicThemeRename<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'b',
    ':DynamicThemeBack<CR>',
    { noremap = true, silent = true }
  )
end

local max_string_length = 40

local function show_main_window()
  local lines = {
    'Dynamic Theme Color Editor',
    '--------------------------',
    '',
    "'?' to view the help menu",
    '',
  }

  local loaded_file = file.read()
  local current_palette = utils.findSelectedTheme(loaded_file).palette

  for name, hex in pairs(current_palette) do
    local display_name = name:gsub('_', ' ')
    -- adding variable space between each key and value creates a visual table
    local padding_spaces = string.rep(' ', max_string_length - #display_name)
    local input_line =
      string.format('  %s:%s%s', display_name, padding_spaces, hex)
    table.insert(lines, input_line)
  end

  vim.api.nvim_buf_set_lines(window_data.buf, 0, -1, false, lines)
end

local create_window = function()
  local width = math.floor(vim.o.columns * 0.5)
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
    vim.api.nvim_buf_set_option(window_data.buf, 'filetype', 'lua')
  end

  show_main_window()

  window_data.win = vim.api.nvim_open_win(window_data.buf, true, config)
end

-- Save changes from input fields
M.save_changes = function()
  local lines = vim.api.nvim_buf_get_lines(window_data.buf, 0, -1, false)
  local updated_palette = {}

  for _, line in ipairs(lines) do
    -- Look for lines that have a color hex code
    local name, hex = line:match '  ([%w%s]+):%s+(%#%x+)'
    if name and hex then
      -- Convert display name back to palette key
      local key = name:gsub(' ', '_')
      updated_palette[key] = hex
    end
  end

  -- Only proceed if we have values to save
  if next(updated_palette) then
    local theme_list = file.read()
    utils.updateSelectedThemePalette(theme_list, updated_palette)

    -- having updated the theme, we first write to file before reloading it
    file.write(theme_list)

    local theme = require 'dynamic-theme.theme'
    theme.update()
  end
end

M.open_window = function()
  if not vim.api.nvim_win_is_valid(window_data.win) then
    create_window()
    create_keymaps()

    -- Find first color line and position cursor at the hex code
    local lines = vim.api.nvim_buf_get_lines(window_data.buf, 0, -1, false)
    for i, line in ipairs(lines) do
      local hex_start = line:find '%#%x+'
      if hex_start then
        vim.api.nvim_win_set_cursor(window_data.win, { i, hex_start })
        break
      end
    end
  end
end

M.close_window = function()
  if vim.api.nvim_win_is_valid(window_data.win) then
    vim.api.nvim_win_close(window_data.win, false)
  end
end

M.back = function()
  show_main_window()
end

M.show_help = function()
  local lines = {
    'Help',
    '--------------------------',
    '',
    "After editing hex color values, press 's' to save changes,",
    "'q' to quit",
    "'r' to reset to the default theme.",
    "'l' to load a theme",
    "'n' to name / rename a theme",
    "'b' to go back to the previous window",
  }

  vim.api.nvim_buf_set_lines(window_data.buf, 0, -1, false, lines)
end

return M
