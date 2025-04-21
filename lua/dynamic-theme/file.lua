local config_path = vim.fn.stdpath 'config'

local M = {}

M.path = config_path .. '/dynamic-theme.json'

M.exists = function()
  local f = io.open(M.path, 'r')
  if f then
    io.close(f)
    return true
  else
    return false
  end
end

return M
