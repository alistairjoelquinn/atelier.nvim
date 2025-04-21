---@return table<string, table> Highlight groups with their settings
return function(colors)
  -- Flatten the nested structure for backward compatibility or simplicity
  local flat_colors = {
    -- Background colors
    bg = colors.ui.bg.main_background,
    bg_lighter = colors.ui.bg.lighter_elements,

    -- Foreground colors
    fg = colors.ui.fg.main_text,
    fg_darker = colors.ui.fg.secondary_text,
    fg_lighter = colors.ui.fg.emphasized_text,

    -- Grey variations
    comment_grey = colors.ui.grey.comments,
    ui_grey = colors.ui.grey.borders_linenumbers,
    ui_grey_lighter = colors.ui.grey.highlighted_elements,

    -- Accent colors
    subtle_yellow = colors.syntax.functions_warnings,
    subtle_pink = colors.syntax.errors_special,
    subtle_green = colors.syntax.strings_success,
    subtle_blue = colors.syntax.variables_identifiers,
    subtle_purple = colors.syntax.types_classes,
  }

  -----------------------------------------------------------
  -- Highlight Group Definitions
  -----------------------------------------------------------
  -- More logically structured highlights based on functionality
  return {
    -----------------------------------------------------------
    -- 1. Editor UI Elements
    -----------------------------------------------------------
    -- 1.1 Core editor elements
    Normal = { fg = flat_colors.fg, bg = flat_colors.bg },
    NormalFloat = { fg = flat_colors.fg, bg = flat_colors.bg },
    Cursor = { fg = flat_colors.bg, bg = flat_colors.fg },
    CursorLine = { bg = flat_colors.bg_lighter },
    LineNr = { fg = flat_colors.ui_grey },
    CursorLineNr = { fg = flat_colors.subtle_yellow },
    SignColumn = { bg = flat_colors.bg },

    -- 1.2 Window elements
    WinSeparator = { fg = flat_colors.ui_grey },
    FloatBorder = { fg = flat_colors.ui_grey },

    -- 1.3 Popup menus
    Pmenu = { fg = flat_colors.fg, bg = flat_colors.bg_lighter },
    PmenuSel = { fg = flat_colors.fg_lighter, bg = flat_colors.ui_grey },
    PmenuSbar = { bg = flat_colors.bg_lighter },
    PmenuThumb = { bg = flat_colors.ui_grey },

    -- 1.4 Search highlighting
    Search = { fg = flat_colors.fg_lighter, bg = flat_colors.ui_grey },
    IncSearch = {
      fg = flat_colors.fg_lighter,
      bg = flat_colors.ui_grey_lighter,
    },
    CurSearch = {
      fg = flat_colors.fg_lighter,
      bg = flat_colors.ui_grey_lighter,
    },

    -- 1.5 Folds
    Folded = { fg = flat_colors.comment_grey, bg = flat_colors.bg_lighter },
    FoldColumn = { fg = flat_colors.ui_grey },

    -- 1.6 Messages and notifications
    ErrorMsg = { fg = flat_colors.subtle_pink },
    WarningMsg = { fg = flat_colors.subtle_yellow },
    MoreMsg = { fg = flat_colors.subtle_green },
    Question = { fg = flat_colors.subtle_blue },

    -----------------------------------------------------------
    -- 2. Syntax Highlighting Groups
    -----------------------------------------------------------
    -- 2.1 Basic syntax elements
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

    -----------------------------------------------------------
    -- 3. TreeSitter Syntax Groups
    -----------------------------------------------------------
    -- 3.1 Functions
    ['@function'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.call'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.builtin'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.import'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.imported'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@function.macro'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@method'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@method.call'] = { fg = flat_colors.subtle_yellow, italic = true },

    -- 3.2 Variables
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

    -- 3.3 Types
    ['@type'] = { fg = flat_colors.subtle_purple },
    ['@type.builtin'] = { fg = flat_colors.subtle_purple },

    -- 3.4 Modules
    ['@module'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@module.name'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@module.import'] = { fg = flat_colors.subtle_yellow, italic = true },
    ['@definition.import'] = { fg = flat_colors.subtle_yellow, italic = true },

    -- 3.5 Other syntax elements
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

    -----------------------------------------------------------
    -- 4. LSP Semantic Tokens
    -----------------------------------------------------------
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

    -----------------------------------------------------------
    -- 5. Diagnostics
    -----------------------------------------------------------
    DiagnosticError = { fg = flat_colors.subtle_pink },
    DiagnosticWarn = { fg = flat_colors.subtle_yellow },
    DiagnosticInfo = { fg = flat_colors.subtle_blue },
    DiagnosticHint = { fg = flat_colors.subtle_green },

    -----------------------------------------------------------
    -- 6. Plugin-specific highlights
    -----------------------------------------------------------
    -- 6.1 NvimTree
    NvimTreeFolderName = { fg = flat_colors.fg_darker },
    NvimTreeOpenedFolderName = { fg = flat_colors.fg_darker },
    NvimTreeEmptyFolderName = { fg = flat_colors.fg_darker },
    NvimTreeFolderIcon = { fg = flat_colors.fg_darker },
  }
end
