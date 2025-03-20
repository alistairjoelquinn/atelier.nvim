local palette = require 'palette'
local create_highlight_groups = require 'create-highlight-groups'

local M = {}

M.setup = function(opts)
  opts = opts or {}

  -- create a new table to add palette as the base
  local custom_palette = {}

  -- copy all values from the base palette
  for k, v in pairs(palette) do
    custom_palette[k] = v
  end

  -- override with values with options passed in by the user
  for k, v in pairs(opts) do
    custom_palette[k] = v
  end

  local highlight_groups = create_highlight_groups(custom_palette)

  for group, settings in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return M
