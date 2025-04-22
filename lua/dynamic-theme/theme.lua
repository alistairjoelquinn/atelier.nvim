---@type DynamicThemePalette
local palette = require 'dynamic-theme.palette'
local file = require 'dynamic-theme.file'

local M = {}

M.initialise_palette = function()
  if not file.exists() then
    file.write(palette)
  end
  local loaded_palette = file.read()
  if loaded_palette then
    return loaded_palette
  else
    vim.notify('Error initialising palette', vim.log.levels.ERROR)
  end
end

M.reset = function()
  file.write(palette)
end

-- Update the theme with updated current palette values
M.update = function()
  local loaded_palette = M.initialise_palette()
  local highlight_groups = M.create_highlight_groups(loaded_palette)

  for group, settings in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

---@return table<string, table> Highlight groups with their settings
M.create_highlight_groups = function(colors)
  local flat_colors = {
    -- Background colors
    bg = colors.main_background,
    bg_lighter = colors.lighter_elements,

    -- Foreground colors
    fg = colors.main_text,
    fg_darker = colors.secondary_text,
    fg_lighter = colors.emphasized_text,

    -- Grey variations
    comment_grey = colors.comments,
    ui_grey = colors.borders_linenumbers,
    ui_grey_lighter = colors.highlighted_elements,

    -- Accent colors
    subtle_yellow = colors.functions_warnings,
    subtle_pink = colors.errors_special,
    subtle_green = colors.strings_success,
    subtle_blue = colors.variables_identifiers,
    subtle_purple = colors.types_classes,
  }

  return {
    -- Core editor elements
    Normal = { fg = flat_colors.fg, bg = flat_colors.bg },
    NormalFloat = { fg = flat_colors.fg, bg = flat_colors.bg },
    Cursor = { fg = flat_colors.bg, bg = flat_colors.fg },
    CursorLine = { bg = flat_colors.bg_lighter },
    LineNr = { fg = flat_colors.ui_grey },
    CursorLineNr = { fg = flat_colors.subtle_yellow },
    SignColumn = { bg = flat_colors.bg },

    -- Window elements
    WinSeparator = { fg = flat_colors.ui_grey },
    FloatBorder = { fg = flat_colors.ui_grey },

    -- Popup menus
    Pmenu = { fg = flat_colors.fg, bg = flat_colors.bg_lighter },
    PmenuSel = { fg = flat_colors.fg_lighter, bg = flat_colors.ui_grey },
    PmenuSbar = { bg = flat_colors.bg_lighter },
    PmenuThumb = { bg = flat_colors.ui_grey },

    -- Search highlighting
    Search = { fg = flat_colors.fg_lighter, bg = flat_colors.ui_grey },
    IncSearch = {
      fg = flat_colors.fg_lighter,
      bg = flat_colors.ui_grey_lighter,
    },
    CurSearch = {
      fg = flat_colors.fg_lighter,
      bg = flat_colors.ui_grey_lighter,
    },

    -- Folds
    Folded = { fg = flat_colors.comment_grey, bg = flat_colors.bg_lighter },
    FoldColumn = { fg = flat_colors.ui_grey },

    -- Messages and notifications
    ErrorMsg = { fg = flat_colors.subtle_pink },
    WarningMsg = { fg = flat_colors.subtle_yellow },
    MoreMsg = { fg = flat_colors.subtle_green },
    Question = { fg = flat_colors.subtle_blue },

    -- Basic syntax elements
    Comment = { fg = flat_colors.comment_grey, italic = true },
    String = { fg = flat_colors.subtle_green },
    Number = { fg = flat_colors.fg_darker },
    Function = { fg = flat_colors.subtle_yellow, italic = true },
    Keyword = { fg = flat_colors.fg },
    Constant = { fg = flat_colors.fg_lighter },
    Type = { fg = flat_colors.subtle_purple },
    Statement = { fg = flat_colors.fg },
    Special = { fg = flat_colors.subtle_pink },
    Identifier = { fg = flat_colors.subtle_blue },
    PreProc = { fg = flat_colors.fg },
    Delimiter = { fg = flat_colors.subtle_green },
    Operator = { fg = flat_colors.fg_darker },
    Variable = { fg = flat_colors.subtle_blue },

    -- TreeSitter Syntax Groups:
    -- Functions
    ['@function'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.call'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.builtin'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.import'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.imported'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.macro'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@method'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@method.call'] = { fg = flat_colors.subtle_yellow, italic = true },

    -- Variables
    ['@variable'] = { fg = flat_colors.subtle_blue },
    ['@variable.member'] = { fg = flat_colors.subtle_blue },
    ['@variable.builtin'] = { fg = flat_colors.subtle_blue },
    ['@variable.parameter'] = { fg = flat_colors.subtle_blue },
    ['@variable.other'] = { fg = flat_colors.subtle_blue },
    ['@variable.other.constant'] = { fg = flat_colors.subtle_blue },
    ['@constant'] = { fg = flat_colors.subtle_blue },
    ['@field'] = { fg = flat_colors.subtle_blue },
    ['@property'] = { fg = flat_colors.subtle_blue },
    ['@parameter'] = { fg = flat_colors.subtle_blue },

    -- Types
    ['@type'] = { fg = flat_colors.subtle_purple },
    ['@type.builtin'] = { fg = flat_colors.subtle_purple },

    -- Modules
    ['@module'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@module.name'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@module.import'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@definition.import'] = { fg = flat_colors.subtle_yellow, italic = true },

    -- Other syntax elements
    ['@keyword'] = { fg = flat_colors.fg },
    ['@string'] = { fg = flat_colors.subtle_green },
    ['@constructor'] = { fg = flat_colors.fg },
    ['@tag'] = { fg = flat_colors.fg },
    ['@tag.attribute'] = { fg = flat_colors.subtle_yellow },
    ['@tag.delimiter'] = { fg = flat_colors.subtle_green },
    ['@punctuation.delimiter'] = { fg = flat_colors.subtle_green },
    ['@punctuation.bracket'] = { fg = flat_colors.subtle_green },
    ['@punctuation.special'] = { fg = flat_colors.subtle_pink },
    ['@comment'] = { fg = flat_colors.comment_grey, italic = true },
    ['@operator'] = { fg = flat_colors.fg_darker },
    ['@definition'] = { fg = flat_colors.subtle_yellow, italic = true },

    -- LSP Semantic Tokens
    ['@lsp.type.class'] = { fg = flat_colors.fg },
    ['@lsp.type.decorator'] = { fg = flat_colors.subtle_pink },
    ['@lsp.type.enum'] = { fg = flat_colors.fg },
    ['@lsp.type.function'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@lsp.type.interface'] = { fg = flat_colors.fg },
    ['@lsp.type.namespace'] = { fg = flat_colors.fg },
    ['@lsp.type.parameter'] = { fg = flat_colors.fg_darker },
    ['@lsp.type.property'] = { fg = flat_colors.subtle_blue },
    ['@lsp.type.variable'] = { fg = flat_colors.subtle_blue },
    ['@lsp.mod.callable'] = { fg = flat_colors.subtle_yellow, italic = true },

    -- Diagnostics
    DiagnosticError = { fg = flat_colors.subtle_pink },
    DiagnosticWarn = { fg = flat_colors.subtle_yellow },
    DiagnosticInfo = { fg = flat_colors.subtle_blue },
    DiagnosticHint = { fg = flat_colors.subtle_green },

    -- NvimTree
    NvimTreeFolderName = { fg = flat_colors.fg_darker },
    NvimTreeOpenedFolderName = { fg = flat_colors.fg_darker },
    NvimTreeEmptyFolderName = { fg = flat_colors.fg_darker },
    NvimTreeFolderIcon = { fg = flat_colors.fg_darker },
  }
end

return M
