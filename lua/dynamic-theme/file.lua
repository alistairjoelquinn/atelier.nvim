local config_path = vim.fn.stdpath 'config'

local M = {}

M.path = config_path .. '/dynamic-theme.json'

--- indicates whether the json file required for this plugin to work, has
--- been written to the file system already or not
---@return boolean
M.exists = function()
  local f = io.open(M.path, 'r')
  if f then
    io.close(f)
    return true
  else
    return false
  end
end

M.read = function()
  local file = io.open(M.path, 'r')
  if file then
    local content = file:read '*all'
    file:close()
    if content then
      local status, decoded = pcall(vim.json.decode, content)
      if status and type(decoded) == 'table' then
        return decoded
      end
    end
  end
end

M.write = function() end

return M
