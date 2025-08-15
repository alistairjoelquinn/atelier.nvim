--- @class DynamicThemeUtils
--- @field findColorschemeByName fun(colorscheme_list: Colorscheme[], target_name: string): Colorscheme|nil, number|nil
--- @field findSelectedColorscheme fun(colorscheme_list: Colorscheme[]): Colorscheme|nil, number|nil
--- @field updateSelectedColorschemePalette fun(colorscheme_list: Colorscheme[], updated_palette: DynamicThemePalette): nil
--- @field apply_hex_highlights fun(): nil
local M = {}

--- check if a hex color is a valid 6 digit hex color
--- @param hex string|nil
--- @return boolean
local function is_valid_hex_color(hex)
  if hex == nil then
    return false
  end
  return hex:match '^#%x%x%x%x%x%x$' ~= nil
end

--[[ Function to determine if a color is dark. We use this when
rendering the hex codes on the color page as we need to use light text over the
top of dark backgrounds for readability. ]]
--- @param hex string
--- @return boolean
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

--- find a colorscheme by name in the colorscheme list
--- @param colorscheme_list Colorscheme[]
--- @param target_name string the name of the colorscheme to find
--- @return Colorscheme|nil colorscheme
--- @return number|nil index
M.findColorschemeByName = function(colorscheme_list, target_name)
  for i, colorscheme in ipairs(colorscheme_list) do
    if colorscheme.name == target_name then
      return colorscheme, i
    end
  end
  return nil, nil
end

--- find the currently selected colorscheme
--- @param colorscheme_list Colorscheme[]
--- @return Colorscheme|nil colorscheme
--- @return number|nil index
M.findSelectedColorscheme = function(colorscheme_list)
  for i, colorscheme in ipairs(colorscheme_list) do
    if colorscheme.selected then
      return colorscheme, i
    end
  end
  return nil, nil
end

--- update the palette of the currently selected colorscheme
--- @param colorscheme_list Colorscheme[]
--- @param updated_palette DynamicThemePalette
M.updateSelectedColorschemePalette = function(colorscheme_list, updated_palette)
  for i, colorscheme in ipairs(colorscheme_list) do
    if colorscheme.selected then
      colorscheme_list[i].palette = updated_palette
    end
  end
end

--- apply hex code highlighting to the buffer
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
