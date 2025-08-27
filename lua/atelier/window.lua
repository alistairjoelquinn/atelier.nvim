local file = require 'atelier.file'
local utils = require 'atelier.utils'
local page = require 'atelier.page'

--- @class AtelierWindow
--- @field save_changes fun(): boolean
--- @field open_window fun(): nil
--- @field close_window fun(): nil
--- @field get_window_data fun(): WindowData
--- @field is_window_valid fun(): boolean
--- @field is_buffer_valid fun(): boolean
--- @field get_buffer fun(): number
--- @field get_window fun(): number
local M = {}

--- @class WindowData
--- @field win number
--- @field buf number

--- window data shared across modules
--- @type WindowData
local window_data = {
  win = -1,
  buf = -1,
}

--- @return WindowData
M.get_window_data = function()
  return window_data
end

--- @return boolean
M.is_window_valid = function()
  return vim.api.nvim_win_is_valid(window_data.win)
end

--- @return boolean
M.is_buffer_valid = function()
  return vim.api.nvim_buf_is_valid(window_data.buf)
end

--- @return number
M.get_buffer = function()
  return window_data.buf
end

--- @return number
M.get_window = function()
  return window_data.win
end

--- window dimensions
--- @type number
local WINDOW_WIDTH = 52
--- @type number
local WINDOW_HEIGHT = 19

--- create a centered floating window
--- @return nil
local create_window = function()
  local col = math.floor((vim.o.columns - WINDOW_WIDTH) / 2)
  local row = math.floor((vim.o.lines - WINDOW_HEIGHT) / 2)

  --- @type table window configuration
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

  page.load_color_page()

  window_data.win = vim.api.nvim_open_win(window_data.buf, true, config)
end

--- save changes from the buffer to the colorscheme
--- @return boolean success: whether the save succeeded
M.save_changes = function()
  local lines = vim.api.nvim_buf_get_lines(window_data.buf, 0, -1, false)
  local updated_palette = {}

  for _, line in ipairs(lines) do
    -- look for lines that have a color hex code
    local name, hex = line:match '  ([%w%s]+):%s+(%#%x+)'
    if name and hex then
      -- convert display name back to palette key
      local key = name:gsub(' ', '_')
      updated_palette[key] = hex
    end
  end

  -- only proceed if we have values to save
  if next(updated_palette) then
    local colorscheme_list = file.read()
    if not colorscheme_list then
      return false
    end

    utils.updateSelectedColorschemePalette(colorscheme_list, updated_palette)

    -- having updated the colorscheme, we first write to file before reloading it
    local success = file.write(colorscheme_list)
    if not success then
      return false
    end

    local colorscheme = require 'atelier.colorscheme'
    colorscheme.apply()
    return true
  end

  return false
end

--- open the colorscheme editor window
--- @return nil
M.open_window = function()
  if not vim.api.nvim_win_is_valid(window_data.win) then
    create_window()

    -- find first color line and position cursor at the hex code
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

--- close the colorscheme editor window
--- @return nil
M.close_window = function()
  if vim.api.nvim_win_is_valid(window_data.win) then
    vim.api.nvim_win_close(window_data.win, false)
    -- ensure window is modifiable when re-opened
    vim.api.nvim_buf_set_option(window_data.buf, 'modifiable', true)
  end
end

return M
