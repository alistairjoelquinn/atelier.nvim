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
    Normal = { fg = colors.keywords_and_delimiters, bg = colors.main_background },
    NormalFloat = { fg = colors.keywords_and_delimiters, bg = colors.main_background },
    Cursor = { fg = colors.main_background, bg = colors.keywords_and_delimiters },
    CursorLine = { bg = colors.current_line_highlight },
    LineNr = { fg = colors.borders_and_line_numbers },
    CursorLineNr = { fg = colors.functions_and_warnings },
    SignColumn = { bg = colors.main_background },

    -- Window elements
    WinSeparator = { fg = colors.borders_and_line_numbers },
    FloatBorder = { fg = colors.borders_and_line_numbers },

    -- Popup menus
    Pmenu = { fg = colors.keywords_and_delimiters, bg = colors.current_line_highlight },
    PmenuSel = {
      fg = colors.emphasised_text,
      bg = colors.borders_and_line_numbers,
    },
    PmenuSbar = { bg = colors.current_line_highlight },
    PmenuThumb = { bg = colors.borders_and_line_numbers },

    -- Search highlighting
    Search = {
      fg = colors.emphasised_text,
      bg = colors.search_highlight_background,
    },
    IncSearch = {
      fg = colors.emphasised_text,
      bg = colors.search_highlight_background,
    },
    CurSearch = {
      fg = colors.emphasised_text,
      bg = colors.search_highlight_background,
    },

    -- Visual mode highlighting
    Visual = {
      bg = colors.visual_highlight_background,
    },
    VisualNOS = {
      bg = colors.visual_highlight_background,
    },

    -- Folds
    Folded = { fg = colors.comments, bg = colors.current_line_highlight },
    FoldColumn = { fg = colors.borders_and_line_numbers },

    -- Messages and notifications
    ErrorMsg = { fg = colors.errors_scope_and_special_characters },
    WarningMsg = { fg = colors.functions_and_warnings },
    MoreMsg = { fg = colors.strings_and_success },
    Question = { fg = colors.variables_and_identifiers },

    -- Basic syntax elements
    Comment = { fg = colors.comments, italic = true },
    String = { fg = colors.strings_and_success },
    Number = { fg = colors.numbers_and_maths_symbols },
    Function = { fg = colors.functions_and_warnings, italic = true },
    Keyword = { fg = colors.keywords_and_delimiters },
    Constant = { fg = colors.errors_scope_and_special_characters },
    Type = { fg = colors.types_and_classes },
    Statement = { fg = colors.keywords_and_delimiters },
    Special = { fg = colors.errors_scope_and_special_characters },
    Identifier = { fg = colors.variables_and_identifiers },
    PreProc = { fg = colors.keywords_and_delimiters },
    Delimiter = { fg = colors.strings_and_success },
    Operator = { fg = colors.numbers_and_maths_symbols },
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
    ['@keyword'] = { fg = colors.keywords_and_delimiters },
    ['@string'] = { fg = colors.strings_and_success },
    ['@constructor'] = { fg = colors.keywords_and_delimiters },
    ['@tag'] = { fg = colors.keywords_and_delimiters },
    ['@tag.attribute'] = { fg = colors.functions_and_warnings },
    ['@tag.delimiter'] = { fg = colors.strings_and_success },
    ['@punctuation.delimiter'] = { fg = colors.strings_and_success },
    ['@punctuation.bracket'] = { fg = colors.strings_and_success },
    ['@punctuation.special'] = {
      fg = colors.errors_scope_and_special_characters,
    },
    ['@comment'] = { fg = colors.comments, italic = true },
    ['@operator'] = { fg = colors.numbers_and_maths_symbols },
    ['@definition'] = { fg = colors.functions_and_warnings, italic = true },

    -- LSP Semantic Tokens
    ['@lsp.type.class'] = { fg = colors.keywords_and_delimiters },
    ['@lsp.type.decorator'] = {
      fg = colors.errors_scope_and_special_characters,
    },
    ['@lsp.type.enum'] = { fg = colors.keywords_and_delimiters },
    ['@lsp.type.function'] = {
      fg = colors.functions_and_warnings,
      italic = true,
    },
    ['@lsp.type.interface'] = { fg = colors.keywords_and_delimiters },
    ['@lsp.type.namespace'] = { fg = colors.keywords_and_delimiters },
    ['@lsp.type.parameter'] = { fg = colors.numbers_and_maths_symbols },
    ['@lsp.type.property'] = { fg = colors.variables_and_identifiers },
    ['@lsp.type.variable'] = { fg = colors.variables_and_identifiers },
    ['@lsp.mod.callable'] = {
      fg = colors.functions_and_warnings,
      italic = true,
    },

    -- Diagnostics
    DiagnosticError = { fg = colors.errors_scope_and_special_characters },
    DiagnosticWarn = { fg = colors.functions_and_warnings },
    DiagnosticInfo = { fg = colors.variables_and_identifiers },
    DiagnosticHint = { fg = colors.strings_and_success },

    -- NvimTree
    NvimTreeFolderName = { fg = colors.numbers_and_maths_symbols },
    NvimTreeOpenedFolderName = { fg = colors.numbers_and_maths_symbols },
    NvimTreeEmptyFolderName = { fg = colors.numbers_and_maths_symbols },
    NvimTreeFolderIcon = { fg = colors.numbers_and_maths_symbols },
  }
end

return M
