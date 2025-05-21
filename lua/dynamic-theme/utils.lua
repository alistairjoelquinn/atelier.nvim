local M = {}

M.findThemeByName = function(themeList, targetName)
  for i, theme in ipairs(themeList) do
    if theme.name == targetName then
      return theme, i
    end
  end
  return nil
end

M.findSelectedTheme = function(themeList)
  for i, theme in ipairs(themeList) do
    if theme.selected then
      return theme, i
    end
  end
  return nil
end

M.updateSelectedTheme = function(themeList, updatedTheme)
  for i, theme in ipairs(themeList) do
    if theme.selected then
      themeList[i] = updatedTheme
    end
  end
end

return M
