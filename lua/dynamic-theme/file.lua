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
    local content = file:read '*all'
    file:close()
    if content then
      local status, decoded = pcall(vim.json.decode, content)
      if status and type(decoded) == 'table' then
        return decoded
      end
    end
  end
  local palette = require 'dynamic-theme.palette'
  return palette
end

---@param palette DynamicThemePalette
M.write = function(palette)
  -- TODO: indent doesn't seem to be working
  local status, encoded = pcall(vim.json.encode, palette, { indent = true })
  if status then
    local file = io.open(M.path, 'w')
    if file then
      file:write(encoded)
      file:close()
      vim.notify('Saved dynamic theme at ' .. M.path, vim.log.levels.INFO)
    end
  end
end

M.save = function() end

return M
