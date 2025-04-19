local M = {}

---@class WindowData
---@field win number Window handle/ID
---@field buf number Buffer handle/ID
---@field content table Buffer content lines
---@type WindowData
local window_data = {
  win = -1,
  buf = -1,
  content = {},
}

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

  -- create buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(window_data.buf) then
    buf = window_data.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Create new window
  local win = vim.api.nvim_open_win(buf, true, config)

  return { buf = buf, win = win }
end

local save_buffer_content = function()
  if vim.api.nvim_buf_is_valid(window_data.buf) then
    local content = vim.api.nvim_buf_get_lines(window_data.buf, 0, -1, false)
    print('this is the contentn:', content)
    window_data.content = content
  end
end

local restore_buffer_content = function()
  if vim.api.nvim_buf_is_valid(window_data.buf) then
    vim.api.nvim_buf_set_lines(
      window_data.buf,
      0,
      -1,
      false,
      window_data.content
    )
  end
end

M.open_window = function()
  if vim.api.nvim_win_is_valid(window_data.win) then
    vim.api.nvim_set_current_win(window_data.win)
    create_keymaps()
    return
  end
  window_data = create_window()
  restore_buffer_content()
  create_keymaps()
end

M.close_window = function()
  if vim.api.nvim_win_is_valid(window_data.win) then
    save_buffer_content()
    vim.api.nvim_win_close(window_data.win, false)
  end
end

return M
