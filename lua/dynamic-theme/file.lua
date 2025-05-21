local config_path = vim.fn.stdpath 'config'

local M = {}

M.path = config_path .. '/dynamic-theme.json'

-- Find first theme with matching name
local findThemeByName = function(themeList, targetName)
  for i, theme in ipairs(themeList) do
    if theme.name == targetName then
      return theme, i -- Return both the theme and its index
    end
  end
  return nil -- Theme not found
end

-- Find first selected theme
local findSelectedTheme = function(themeList)
  for i, theme in ipairs(themeList) do
    if theme.selected then
      return theme, i
    end
  end
  return nil -- No selected theme found
end

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
  end
  local palette = require 'dynamic-theme.palette'
  return palette
end

M.write = function(palette)
  local status, encoded = pcall(vim.json.encode, palette, { indent = true })
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
