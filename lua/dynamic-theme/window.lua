local file = require 'dynamic-theme.file'
local utils = require 'dynamic-theme.utils'
local page = require 'dynamic-theme.page'

--- @class DynamicThemeWindow
--- @field save_changes fun(): boolean
--- @field open_window fun(): nil
--- @field close_window fun(): nil
local M = {}

--- @class WindowData
--- @field win number window handle
--- @field buf number buffer handle

--- global window data shared across modules
--- @type WindowData
WINDOW_DATA = {
  win = -1,
  buf = -1,
}

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
  if not vim.api.nvim_buf_is_valid(WINDOW_DATA.buf) then
    WINDOW_DATA.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(WINDOW_DATA.buf, 'filetype', 'text')
  end

  page.load_color_page()

  WINDOW_DATA.win = vim.api.nvim_open_win(WINDOW_DATA.buf, true, config)
end

--- save changes from the buffer to the colorscheme
--- @return boolean success: whether the save succeeded
M.save_changes = function()
  local lines = vim.api.nvim_buf_get_lines(WINDOW_DATA.buf, 0, -1, false)
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

    local colorscheme = require 'lua.dynamic-theme.colorscheme'
    colorscheme.apply()
    return true
  end

  return false
end

--- open the colorscheme editor window
--- @return nil
M.open_window = function()
  if not vim.api.nvim_win_is_valid(WINDOW_DATA.win) then
    create_window()

    -- find first color line and position cursor at the hex code
    local lines = vim.api.nvim_buf_get_lines(WINDOW_DATA.buf, 0, -1, false)
    for i, line in ipairs(lines) do
      local hex_start = line:find '%#%x+'
      if hex_start then
        vim.api.nvim_win_set_cursor(WINDOW_DATA.win, { i, hex_start })
        break
      end
    end
  end
end

--- close the colorscheme editor window
--- @return nil
M.close_window = function()
  if vim.api.nvim_win_is_valid(WINDOW_DATA.win) then
    vim.api.nvim_win_close(WINDOW_DATA.win, false)
    -- ensure window is modifiable when re-opened
    vim.api.nvim_buf_set_option(WINDOW_DATA.buf, 'modifiable', true)
  end
end

return M
