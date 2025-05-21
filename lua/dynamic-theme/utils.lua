local M = {}

M.findThemeByName = function(theme_list, target_name)
  for i, theme in ipairs(theme_list) do
    if theme.name == target_name then
      return theme, i
    end
  end
  return nil
end

M.findSelectedTheme = function(theme_list)
  for i, theme in ipairs(theme_list) do
    if theme.selected then
      return theme, i
    end
  end
  return nil
end

M.updateSelectedThemePalette = function(theme_list, updated_palette)
  for i, theme in ipairs(theme_list) do
    if theme.selected then
      theme_list[i].palette = updated_palette
    end
  end
end

return M
