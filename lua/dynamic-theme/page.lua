local file = require 'dynamic-theme.file'
local utils = require 'dynamic-theme.utils'
local keymaps = require 'dynamic-theme.keymaps'

---@class DynamicThemePage
local M = {}

---set buffer editable state
---@param editable boolean whether the buffer should be editable
---@return nil
local set_buffer_editable = function(editable)
  vim.api.nvim_buf_set_option(WINDOW_DATA.buf, 'modifiable', editable)
  vim.api.nvim_buf_set_option(WINDOW_DATA.buf, 'readonly', not editable)
end

---maximum string length for formatting the color editor
---@type number
local MAX_STRING_LENGTH = 40

---show the help page
---@return nil
M.show_help_page = function()
  ---@type string[] lines to display in the buffer
  local lines = {
    '                        Help',
    '             --------------------------',
    '  Color page commands:',
    "  's' to save changes",
    "  'r' to reset plugin defaults",
    "  't' to go to the theme page",
    "  'q' to quit",
    '',
    '  Theme page commands',
    "  '1-8' to select a theme by number",
    "  'c' to go color page",
    "  'q' to quit",
    '',
    '  Help page commands',
    "  'c' to go color page",
    "  't' to go to the theme page",
    "  'q' to quit",
  }

  -- make buffer modifiable first (in case it was previously set to non-modifiable)
  set_buffer_editable(true)

  vim.api.nvim_buf_set_lines(WINDOW_DATA.buf, 0, -1, false, lines)

  -- ensure buffer is no longer editable
  set_buffer_editable(false)
  keymaps.create_help_page_keymaps()
end

---show the theme selection page
---@return nil
M.show_theme_page = function()
  ---@type string[] lines to display in the buffer
  local lines = {
    '                    Available Themes',
    '             --------------------------',
    '',
  }

  local loaded_file = file.read()
  if not loaded_file then
    vim.notify('Error loading themes', vim.log.levels.ERROR)
    return
  end

  for i, theme in ipairs(loaded_file) do
    table.insert(lines, '  ' .. string.format('%d. %s', i, theme.name))
  end

  -- make buffer modifiable first (in case it was previously set to non-modifiable)
  set_buffer_editable(true)

  vim.api.nvim_buf_set_lines(WINDOW_DATA.buf, 0, -1, false, lines)

  -- ensure buffer is no longer editable
  set_buffer_editable(false)
  keymaps.create_theme_page_keymaps()
end

---load the color editor page
---@return nil
M.load_color_page = function()
  local loaded_file = file.read()
  if not loaded_file then
    vim.notify('Error loading themes', vim.log.levels.ERROR)
    return
  end
  
  local current_theme = utils.findSelectedTheme(loaded_file)
  if current_theme == nil then
    vim.notify('Warning, theme not detected', vim.log.levels.ERROR)
    return
  end

  local current_palette = current_theme.palette
  local title = 'Color Editor ( ' .. current_theme.name .. ' )'

  -- calculate padding to center the title within the window width
  local title_width = vim.fn.strdisplaywidth(title)
  local padding = math.floor((52 - title_width) / 2)
  local centered_title = string.rep(' ', padding) .. title

  ---@type string[] lines to display in the buffer
  local lines = {
    centered_title,
    '             -------------------------',
    "             '?' to view the help menu",
    '',
  }

  for name, hex in pairs(current_palette) do
    local display_name = name:gsub('_', ' ')
    -- adding variable space between each key and value creates a visual table
    local padding_spaces = string.rep(' ', MAX_STRING_LENGTH - #display_name)
    local input_line =
      string.format('  %s:%s%s', display_name, padding_spaces, hex)
    table.insert(lines, input_line)
  end

  set_buffer_editable(true)

  keymaps.create_color_page_keymaps()
  vim.api.nvim_buf_set_lines(WINDOW_DATA.buf, 0, -1, false, lines)

  utils.apply_hex_highlights()

  -- set up autocmd to refresh highlights when the buffer content changes
  vim.api.nvim_create_autocmd('TextChanged', {
    buffer = WINDOW_DATA.buf,
    callback = function()
      utils.apply_hex_highlights()
    end,
  })

  vim.api.nvim_create_autocmd('TextChangedI', {
    buffer = WINDOW_DATA.buf,
    callback = function()
      utils.apply_hex_highlights()
    end,
  })
end

---show the color editor page
---@return nil
M.show_color_page = function()
  M.load_color_page()
end

return M
