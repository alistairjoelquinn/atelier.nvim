local vim = vim
---@type DynamicThemePalette
local palette = require 'dynamic-theme.palette'
local window = require 'dynamic-theme.window'
---@type fun(colors: DynamicThemePalette): table<string, table>
local create_highlight_groups = require 'dynamic-theme.create-highlight-groups'

---@param filepath string
---@return boolean
local function file_exists(filepath)
  local f = io.open(filepath, 'r')
  if f then
    io.close(f)
    return true
  else
    return false
  end
end

local config_path = vim.fn.stdpath 'config'
local json_path = config_path .. '/dynamic-theme.json'

---@return table
local initialise_theme = function()
  if file_exists(json_path) then
    print 'file exists'
    local f = io.open(json_path, 'r')
    if f then
      local content = f:read '*all'
      f:close()

      -- Parse JSON if content exists
      if content and content ~= '' then
        local status, decoded = pcall(vim.json.decode, content)
        if status and type(decoded) == 'table' then
          return decoded
        end
      end
    end
  else
    print 'file does not exist'
    -- Create the file with default palette if it doesn't exist
    local status, encoded = pcall(vim.json.encode, palette)
    if status then
      local f = io.open(json_path, 'w')
      if f then
        f:write(encoded)
        f:close()
        vim.notify(
          'Created default theme file at ' .. json_path,
          vim.log.levels.INFO
        )
      end
    end
    return palette
  end

  -- If we reach here, something went wrong with reading or creating the file
  print 'There was an issue loading the palette'
  -- Return the default palette
  return palette
end

---@class DynamicThemeModule
local M = {}

-- TODO:
--   command to save changes by user
--   write saved values to json file in the root of the directory
--   OPTIONS
--      allow persisting multiple themes which can be toggled
--      allow to reset back to the default them from when first loading the plugin

---@param opts? table Options to override the default palette colors
---@return nil
M.setup = function(opts)
  opts = opts or {}

  -- Get the palette values from saved theme or create a new theme file
  local custom_palette = initialise_theme()

  -- If the palette doesn't have all the expected structure, fill in from defaults
  for k, v in pairs(palette) do
    if custom_palette[k] == nil then
      custom_palette[k] = v
    end
  end

  -- override with values with options passed in by the user
  for k, v in pairs(opts) do
    custom_palette[k] = v
  end

  ---@type table<string, table>
  local highlight_groups = create_highlight_groups(custom_palette)

  for group, settings in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end

  -- Create commands for opening and closing the window
  vim.api.nvim_create_user_command('DynamicThemeOpen', function()
    window.open_window()
  end, {})

  vim.api.nvim_create_user_command('DynamicThemeClose', function()
    window.close_window()
  end, {})

  -- Add command to save theme
  vim.api.nvim_create_user_command('DynamicThemeSave', function()
    -- TODO: Get the current theme values and save to json file
    local config_path = vim.fn.stdpath 'config'
    local json_path = config_path .. '/dynamic-theme.json'

    -- For now, just save a message that this feature is coming soon
    vim.notify('Theme saving feature coming soon!', vim.log.levels.INFO)
  end, {})
end

return M
