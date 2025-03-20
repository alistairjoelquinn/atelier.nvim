return function(opts)
  opts = opts or {}
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
