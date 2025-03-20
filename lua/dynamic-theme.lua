local palette = require 'palette'
local groups = require 'groups'

local M

M.setup = function(opts)
  opts = opts or {}

  -- create a new table with palette as the base
  local palette_overwrite = {}

  -- copy all values from the base palette
  for k, v in pairs(palette) do
    palette_overwrite[k] = v
  end

  -- override with values with options passed in by the user
  if opts.overwrite then
    for k, v in pairs(opts.overwrite) do
      palette_overwrite[k] = v
    end
  end

  local highlight_groups = groups.create_theme_groups(palette_overwrite)

  for group, settings in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return M
