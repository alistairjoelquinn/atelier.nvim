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

local set_buffer_editable = function(editable)
  vim.api.nvim_buf_set_option(window_data.buf, 'modifiable', editable)
  vim.api.nvim_buf_set_option(window_data.buf, 'readonly', not editable)
end

local clear_buffer_keymaps = function()
  local keys_to_clear = {
    's',
    'r',
    't',
    'q',
    '?',
    'l',
    'n',
    'c',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  }
  for _, key in ipairs(keys_to_clear) do
    pcall(vim.api.nvim_buf_del_keymap, window_data.buf, 'n', key)
  end
end

-- Create keymap for navigation and saving
local create_color_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

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
    't',
    ':DynamicThemeThemePage<CR>',
    { noremap = true, silent = true }
  )

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
    '?',
    ':DynamicThemeHelpPage<CR>',
    { noremap = true, silent = true }
  )
end

local create_theme_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

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
    'c',
    ':DynamicThemeColorPage<CR>',
    { noremap = true, silent = true }
  )

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
    '?',
    ':DynamicThemeHelpPage<CR>',
    { noremap = true, silent = true }
  )

  -- Add number key mappings for theme selection
  local theme = require 'dynamic-theme.theme'
  for i = 1, 8 do
    vim.api.nvim_buf_set_keymap(window_data.buf, 'n', tostring(i), '', {
      noremap = true,
      silent = true,
      callback = function()
        theme.select_theme(i)
      end,
    })
  end
end

local create_help_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'c',
    ':DynamicThemeColorPage<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    't',
    ':DynamicThemeThemePage<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    { noremap = true, silent = true }
  )
end

local MAX_STRING_LENGTH = 40
local WINDOW_WIDTH = 52
local WINDOW_HEIGHT = 19

local function load_color_page()
  local lines = {
    '             Dynamic Theme Color Editor',
    '             --------------------------',
    "             '?' to view the help menu",
    '',
  }

  local loaded_file = file.read()
  local current_palette = utils.findSelectedTheme(loaded_file).palette

  for name, hex in pairs(current_palette) do
    local display_name = name:gsub('_', ' ')
    -- adding variable space between each key and value creates a visual table
    local padding_spaces = string.rep(' ', MAX_STRING_LENGTH - #display_name)
    local input_line =
      string.format('  %s:%s%s', display_name, padding_spaces, hex)
    table.insert(lines, input_line)
  end

  set_buffer_editable(true)

  create_color_page_keymaps()
  vim.api.nvim_buf_set_lines(window_data.buf, 0, -1, false, lines)
end

local create_window = function()
  local col = math.floor((vim.o.columns - WINDOW_WIDTH) / 2)
  local row = math.floor((vim.o.lines - WINDOW_HEIGHT) / 2)

  local config = {
    style = 'minimal',
    border = 'rounded',
    relative = 'editor',
    width = WINDOW_WIDTH,
    height = WINDOW_HEIGHT,
    row = row,
    col = col,
  }

  -- we always try and reuse the buffer from the previous open window, though
  -- always create a new window as the old window can't be reused
  if not vim.api.nvim_buf_is_valid(window_data.buf) then
    window_data.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(window_data.buf, 'filetype', 'text')
  end

  load_color_page()

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
    -- ensure window is modifiable when re-opened
    vim.api.nvim_buf_set_option(window_data.buf, 'modifiable', true)
  end
end

M.show_help_page = function()
  local lines = {
    '                        Help',
    '             --------------------------',
    '',
    '  Color page commands:',
    "  's' to save changes",
    "  'r' to reset plugin defaults",
    "  't' to go to the theme page",
    "  'q' to quit",
    '',
    '  Theme page commands',
    "  '1-8' to select a theme by number",
    "  'l' to load a theme",
    "  'n' to name / rename a theme",
    "  'c' to go color page",
    "  'q' to quit",
    '',
    '  Help page commands',
    "  'c' to go color page",
    "  't' to go to the theme page",
    "  'q' to quit",
  }

  -- Make buffer modifiable FIRST (in case it was previously set to non-modifiable)
  set_buffer_editable(true)

  vim.api.nvim_buf_set_lines(window_data.buf, 0, -1, false, lines)

  -- ensure buffer is no longer editable
  set_buffer_editable(false)
  create_help_page_keymaps()
end

M.show_theme_page = function()
  local lines = {
    '                    Available Themes',
    '             --------------------------',
    '',
  }

  local loaded_file = file.read()

  for i, theme in ipairs(loaded_file) do
    table.insert(lines, '  ' .. string.format('%d. %s', i, theme.name))
  end

  -- Make buffer modifiable FIRST (in case it was previously set to non-modifiable)

  set_buffer_editable(true)

  vim.api.nvim_buf_set_lines(window_data.buf, 0, -1, false, lines)

  -- ensure buffer is no longer editable
  set_buffer_editable(false)
  create_theme_page_keymaps()
end

M.show_color_page = function()
  load_color_page()
end

return M
