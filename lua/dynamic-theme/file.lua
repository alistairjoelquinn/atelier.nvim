local config_path = vim.fn.stdpath 'config'

local M = {}

M.path = config_path .. '/dynamic-theme.json'

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
    local content = file:read '*a'
    file:close()
    if content then
      local status, decoded = pcall(vim.json.decode, content)
      if status and type(decoded) == 'table' then
        return decoded
      end
    end
  else
    vim.notify('Error reading from theme file', vim.log.levels.ERROR)
  end
end

M.write = function(themeList)
  local status, encoded = pcall(vim.json.encode, themeList, { indent = true })
  if status then
    local file = io.open(M.path, 'w')
    if file then
      file:write(encoded)
      file:close()
    end
  end
end

M.save = function()
  local window = require 'dynamic-theme.window'
  window.save_changes()
end

return M
