local M = {}

---@class WindowData
---@field win number Window handle/ID
---@field buf number Buffer handle/ID

---@type WindowData
local window_data = {
  win = -1,
  buf = -1,
}

-- Map 'q' to close the window
local create_keymaps = function()
  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    { noremap = true, silent = true }
  )
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

  window_data.win = vim.api.nvim_open_win(window_data.buf, true, config)
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
