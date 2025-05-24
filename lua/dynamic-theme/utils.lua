---@class DynamicThemeUtils
---@field findThemeByName fun(theme_list: Theme[], target_name: string): Theme|nil, number|nil find a theme by name in the theme list
---@field findSelectedTheme fun(theme_list: Theme[]): Theme|nil, number|nil find the currently selected theme
---@field updateSelectedThemePalette fun(theme_list: Theme[], updated_palette: DynamicThemePalette): nil update the palette of the currently selected theme
---@field apply_hex_highlights fun(): nil apply hex code highlighting to the buffer
local M = {}

---check if a hex color is a valid 6 digit hex color
---@param hex string|nil the hex color to validate
---@return boolean whether the hex color is valid
local function is_valid_hex_color(hex)
  return hex and hex:match '^#%x%x%x%x%x%x$' ~= nil
end

--[[ Function to determine if a color is dark. We use this when
rendering the hex codes on the color page as we need to use light text over the
top of dark backgrounds for readability. ]]
---@param hex string the hex color to check
---@return boolean whether the color is dark
local function is_dark_color(hex)
  if not is_valid_hex_color(hex) then
    return false
  end

  -- extract RGB components
  local r = tonumber(hex:sub(2, 3), 16) or 0
  local g = tonumber(hex:sub(4, 5), 16) or 0
  local b = tonumber(hex:sub(6, 7), 16) or 0

  -- calculate perceived brightness using common formula
  local brightness = (0.299 * r + 0.587 * g + 0.114 * b) / 255

  return brightness < 0.5
end

---find a theme by name in the theme list
---@param theme_list Theme[] the list of themes to search
---@param target_name string the name of the theme to find
---@return Theme|nil theme the found theme or nil
---@return number|nil index the index of the found theme or nil
M.findThemeByName = function(theme_list, target_name)
  for i, theme in ipairs(theme_list) do
    if theme.name == target_name then
      return theme, i
    end
  end
  return nil, nil
end

---find the currently selected theme
---@param theme_list Theme[] the list of themes to search
---@return Theme|nil theme the selected theme or nil
---@return number|nil index the index of the selected theme or nil
M.findSelectedTheme = function(theme_list)
  for i, theme in ipairs(theme_list) do
    if theme.selected then
      return theme, i
    end
  end
  return nil, nil
end

---update the palette of the currently selected theme
---@param theme_list Theme[] the list of themes to update
---@param updated_palette DynamicThemePalette the new palette to apply
M.updateSelectedThemePalette = function(theme_list, updated_palette)
  for i, theme in ipairs(theme_list) do
    if theme.selected then
      theme_list[i].palette = updated_palette
    end
  end
end

---apply hex code highlighting to the buffer
M.apply_hex_highlights = function()
  -- clear existing highlights
  vim.api.nvim_buf_clear_namespace(WINDOW_DATA.buf, -1, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(WINDOW_DATA.buf, 0, -1, false)
  for i, line in ipairs(lines) do
    local _, hex_start = line:find '%s+#'
    if hex_start then
      local hex_code = line:match('%#%x+', hex_start - 1)
      if hex_code and is_valid_hex_color(hex_code) then
        -- create a highlight group for each hex code
        local hl_group = 'DynamicThemeColor' .. hex_code:gsub('#', '')

        -- choose text color based on background darkness
        local fg_color = is_dark_color(hex_code) and '#FFFFFF' or '#000000'

        -- use pcall to gracefully handle the possibility of an error here
        local success, _ = pcall(function()
          vim.api.nvim_set_hl(0, hl_group, { bg = hex_code, fg = fg_color })
        end)

        if success then
          vim.api.nvim_buf_add_highlight(
            WINDOW_DATA.buf,
            -1, -- namespace id (-1 for a new namespace)
            hl_group,
            i - 1, -- line index (0-based)
            hex_start - 1, -- start column (0-based)
            hex_start - 1 + #hex_code -- end column
          )
        end
      end
    end
  end
end

return M
