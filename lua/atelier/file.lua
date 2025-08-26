--- @class Colorscheme
--- @field name string the name of the colorscheme
--- @field selected boolean whether this colorscheme is currently selected
--- @field palette AtelierPalette|nil the color palette for this colorscheme

--- @class AtelierFile
--- @field path string the path to the configuration JSON file
--- @field exists fun(): boolean check if the atelier file exists
--- @field read fun(): Colorscheme[]|nil read and parse the atelier file
--- @field write fun(colorscheme_list: Colorscheme[]): boolean write colorschemes to the colorscheme file
--- @field save fun(): nil save changes from the UI to the colorscheme file
local M = {}

local config_path = vim.fn.stdpath 'config'
M.path = config_path .. '/atelier.json'

--- check if the colorscheme file exists
--- @return boolean
M.exists = function()
  local f = io.open(M.path, 'r')
  if f then
    io.close(f)
    return true
  else
    return false
  end
end

--- read and parse the colorscheme file
--- @return Colorscheme[]|nil the array of colorscheme or nil if reading failed
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
    vim.notify('Error reading from colorscheme file', vim.log.levels.ERROR)
  end
  return nil
end

--- write colorscheme to the colorscheme file
--- @param colorscheme_list Colorscheme[] the array of colorschemes to write
--- @return boolean whether the write operation succeeded
M.write = function(colorscheme_list)
  local status, encoded =
    pcall(vim.json.encode, colorscheme_list, { indent = true })
  if status then
    local file = io.open(M.path, 'w')
    if file then
      file:write(encoded)
      file:close()
      return true
    end
  end
  return false
end

--- save changes from the UI to the colorscheme file
M.save = function()
  local window = require 'atelier.window'
  window.save_changes()
end

return M
