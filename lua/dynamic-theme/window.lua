local M = {}

---@class WindowData
---@field win number Window handle/ID
---@field buf number Buffer handle/ID

---@type WindowData|nil
local window_data = nil

-- Map 'q' to close the window
local create_keymaps = function()
  if window_data then
    vim.api.nvim_buf_set_keymap(
      window_data.buf,
      'n',
      'q',
      ':DynamicThemeClose<CR>',
      { noremap = true, silent = true }
    )
  end
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

  -- create new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Create new window
  local win = vim.api.nvim_open_win(buf, true, config)

  return { buf = buf, win = win }
end

M.open_window = function()
  if window_data and vim.api.nvim_win_is_valid(window_data.win) then
    vim.api.nvim_set_current_win(window_data.win)
    create_keymaps()
    return
  end
  window_data = create_window()
  create_keymaps()
end

M.close_window = function()
  if window_data and vim.api.nvim_win_is_valid(window_data.win) then
    vim.api.nvim_win_close(window_data.win, true)
    window_data = nil
  end
end

return M
