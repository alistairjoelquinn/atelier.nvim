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
  M.update()
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
  return {
    -- Core editor elements
    Normal = { fg = colors.main_text, bg = colors.main_background },
    NormalFloat = { fg = colors.main_text, bg = colors.main_background },
    Cursor = { fg = colors.main_background, bg = colors.main_text },
    CursorLine = { bg = colors.lighter_background },
    LineNr = { fg = colors.borders_and_linenumbers },
    CursorLineNr = { fg = colors.functions_and_warnings },
    SignColumn = { bg = colors.main_background },

    -- Window elements
    WinSeparator = { fg = colors.borders_and_linenumbers },
    FloatBorder = { fg = colors.borders_and_linenumbers },

    -- Popup menus
    Pmenu = { fg = colors.main_text, bg = colors.lighter_background },
    PmenuSel = {
      fg = colors.emphasized_text,
      bg = colors.borders_and_linenumbers,
    },
    PmenuSbar = { bg = colors.lighter_background },
    PmenuThumb = { bg = colors.borders_and_linenumbers },

    -- Search highlighting
    Search = {
      fg = colors.emphasized_text,
      bg = colors.borders_and_linenumbers,
    },
    IncSearch = {
      fg = colors.emphasized_text,
      bg = colors.highlighted_elements,
    },
    CurSearch = {
      fg = colors.emphasized_text,
      bg = colors.highlighted_elements,
    },

    -- Folds
    Folded = { fg = colors.comments, bg = colors.lighter_background },
    FoldColumn = { fg = colors.borders_and_linenumbers },

    -- Messages and notifications
    ErrorMsg = { fg = colors.errors_and_special_characters },
    WarningMsg = { fg = colors.functions_and_warnings },
    MoreMsg = { fg = colors.strings_and_success },
    Question = { fg = colors.variables_and_identifiers },

    -- Basic syntax elements
    Comment = { fg = colors.comments, italic = true },
    String = { fg = colors.strings_and_success },
    Number = { fg = colors.secondary_text },
    Function = { fg = colors.functions_and_warnings, italic = true },
    Keyword = { fg = colors.main_text },
    Constant = { fg = colors.emphasized_text },
    Type = { fg = colors.types_and_classes },
    Statement = { fg = colors.main_text },
    Special = { fg = colors.errors_and_special_characters },
    Identifier = { fg = colors.variables_and_identifiers },
    PreProc = { fg = colors.main_text },
    Delimiter = { fg = colors.strings_and_success },
    Operator = { fg = colors.secondary_text },
    Variable = { fg = colors.variables_and_identifiers },

    -- TreeSitter Syntax Groups:
    -- Functions
    ['@function'] = { fg = colors.functions_and_warnings, italic = true },
    ['@function.call'] = { fg = colors.functions_and_warnings, italic = true },
    ['@function.builtin'] = {
      fg = colors.functions_and_warnings,
      italic = true,
    },
    ['@function.import'] = { fg = colors.functions_and_warnings, italic = true },
    ['@function.imported'] = {
      fg = colors.functions_and_warnings,
      italic = true,
    },
    ['@function.macro'] = { fg = colors.functions_and_warnings, italic = true },
    ['@method'] = { fg = colors.functions_and_warnings, italic = true },
    ['@method.call'] = { fg = colors.functions_and_warnings, italic = true },

    -- Variables
    ['@variable'] = { fg = colors.variables_and_identifiers },
    ['@variable.member'] = { fg = colors.variables_and_identifiers },
    ['@variable.builtin'] = { fg = colors.variables_and_identifiers },
    ['@variable.parameter'] = { fg = colors.variables_and_identifiers },
    ['@variable.other'] = { fg = colors.variables_and_identifiers },
    ['@variable.other.constant'] = { fg = colors.variables_and_identifiers },
    ['@constant'] = { fg = colors.variables_and_identifiers },
    ['@field'] = { fg = colors.variables_and_identifiers },
    ['@property'] = { fg = colors.variables_and_identifiers },
    ['@parameter'] = { fg = colors.variables_and_identifiers },

    -- Types
    ['@type'] = { fg = colors.types_and_classes },
    ['@type.builtin'] = { fg = colors.types_and_classes },

    -- Modules
    ['@module'] = { fg = colors.functions_and_warnings, italic = true },
    ['@module.name'] = { fg = colors.functions_and_warnings, italic = true },
    ['@module.import'] = { fg = colors.functions_and_warnings, italic = true },
    ['@definition.import'] = {
      fg = colors.functions_and_warnings,
      italic = true,
    },

    -- Other syntax elements
    ['@keyword'] = { fg = colors.main_text },
    ['@string'] = { fg = colors.strings_and_success },
    ['@constructor'] = { fg = colors.main_text },
    ['@tag'] = { fg = colors.main_text },
    ['@tag.attribute'] = { fg = colors.functions_and_warnings },
    ['@tag.delimiter'] = { fg = colors.strings_and_success },
    ['@punctuation.delimiter'] = { fg = colors.strings_and_success },
    ['@punctuation.bracket'] = { fg = colors.strings_and_success },
    ['@punctuation.special'] = { fg = colors.errors_and_special_characters },
    ['@comment'] = { fg = colors.comments, italic = true },
    ['@operator'] = { fg = colors.secondary_text },
    ['@definition'] = { fg = colors.functions_and_warnings, italic = true },

    -- LSP Semantic Tokens
    ['@lsp.type.class'] = { fg = colors.main_text },
    ['@lsp.type.decorator'] = { fg = colors.errors_and_special_characters },
    ['@lsp.type.enum'] = { fg = colors.main_text },
    ['@lsp.type.function'] = {
      fg = colors.functions_and_warnings,
      italic = true,
    },
    ['@lsp.type.interface'] = { fg = colors.main_text },
    ['@lsp.type.namespace'] = { fg = colors.main_text },
    ['@lsp.type.parameter'] = { fg = colors.secondary_text },
    ['@lsp.type.property'] = { fg = colors.variables_and_identifiers },
    ['@lsp.type.variable'] = { fg = colors.variables_and_identifiers },
    ['@lsp.mod.callable'] = {
      fg = colors.functions_and_warnings,
      italic = true,
    },

    -- Diagnostics
    DiagnosticError = { fg = colors.errors_and_special_characters },
    DiagnosticWarn = { fg = colors.functions_and_warnings },
    DiagnosticInfo = { fg = colors.variables_and_identifiers },
    DiagnosticHint = { fg = colors.strings_and_success },

    -- NvimTree
    NvimTreeFolderName = { fg = colors.secondary_text },
    NvimTreeOpenedFolderName = { fg = colors.secondary_text },
    NvimTreeEmptyFolderName = { fg = colors.secondary_text },
    NvimTreeFolderIcon = { fg = colors.secondary_text },
  }
end

return M
