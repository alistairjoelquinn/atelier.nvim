---@param colors DynamicThemePalette
---@return table<string, table> Highlight groups with their settings
return function(colors)
  return {
    -- editor basics
    Normal = { fg = colors.fg, bg = colors.bg },
    NormalFloat = { fg = colors.fg, bg = colors.bg },
    Cursor = { fg = colors.bg, bg = colors.fg },
    CursorLine = { bg = colors.bg_lighter },
    LineNr = { fg = colors.ui_grey },
    CursorLineNr = { fg = colors.subtle_yellow },
    SignColumn = { bg = colors.bg },

    -- syntax highlighting
    Comment = { fg = colors.comment_grey, italic = true },
    String = { fg = colors.subtle_green },
    Number = { fg = colors.fg_darker },
    Function = { fg = colors.subtle_yellow, italic = true },
    Keyword = { fg = colors.fg },
    Constant = { fg = colors.fg_lighter },
    Type = { fg = colors.fg },
    Statement = { fg = colors.fg },
    Special = { fg = colors.subtle_pink },
    Identifier = { fg = colors.subtle_blue },
    PreProc = { fg = colors.fg },
    Delimiter = { fg = colors.subtle_green },
    Operator = { fg = colors.fg_darker },
    Variable = { fg = colors.subtle_blue },

    -- ui elements
    WinSeparator = { fg = colors.ui_grey },
    FloatBorder = { fg = colors.ui_grey },

    -- popup menus
    Pmenu = { fg = colors.fg, bg = colors.bg_lighter },
    PmenuSel = { fg = colors.fg_lighter, bg = colors.ui_grey },
    PmenuSbar = { bg = colors.bg_lighter },
    PmenuThumb = { bg = colors.ui_grey },

    -- search
    Search = { fg = colors.fg_lighter, bg = colors.ui_grey },
    IncSearch = { fg = colors.fg_lighter, bg = colors.ui_grey_lighter },
    CurSearch = { fg = colors.fg_lighter, bg = colors.ui_grey_lighter },

    -- folds
    Folded = { fg = colors.comment_grey, bg = colors.bg_lighter },
    FoldColumn = { fg = colors.ui_grey },

    -- messages
    ErrorMsg = { fg = colors.subtle_pink },
    WarningMsg = { fg = colors.subtle_yellow },
    MoreMsg = { fg = colors.subtle_green },
    Question = { fg = colors.subtle_blue },

    -- treesitter groups
    ['@function'] = { fg = colors.subtle_yellow, italic = true },
    ['@function.call'] = { fg = colors.subtle_yellow, italic = true },
    ['@function.builtin'] = { fg = colors.subtle_yellow, italic = true },
    ['@function.import'] = { fg = colors.subtle_yellow, italic = true },
    ['@function.imported'] = { fg = colors.subtle_yellow, italic = true },
    ['@function.macro'] = { fg = colors.subtle_yellow, italic = true },
    ['@method'] = { fg = colors.subtle_yellow, italic = true },
    ['@method.call'] = { fg = colors.subtle_yellow, italic = true },

    ['@variable'] = { fg = colors.subtle_blue },
    ['@variable.member'] = { fg = colors.subtle_blue },
    ['@variable.builtin'] = { fg = colors.subtle_blue },
    ['@variable.parameter'] = { fg = colors.subtle_blue },
    ['@variable.other'] = { fg = colors.subtle_blue },
    ['@variable.other.constant'] = { fg = colors.subtle_blue },
    ['@constant'] = { fg = colors.subtle_blue },
    ['@field'] = { fg = colors.subtle_blue },
    ['@property'] = { fg = colors.subtle_blue },
    ['@parameter'] = { fg = colors.subtle_blue },

    ['@type'] = { fg = colors.subtle_purple },
    ['@type.builtin'] = { fg = colors.subtle_purple },

    ['@module'] = { fg = colors.subtle_yellow, italic = true },
    ['@module.name'] = { fg = colors.subtle_yellow, italic = true },
    ['@module.import'] = { fg = colors.subtle_yellow, italic = true },
    ['@definition.import'] = { fg = colors.subtle_yellow, italic = true },

    -- misc
    ['@keyword'] = { fg = colors.fg },
    ['@string'] = { fg = colors.subtle_green },
    ['@constructor'] = { fg = colors.fg },
    ['@tag'] = { fg = colors.fg },
    ['@tag.attribute'] = { fg = colors.subtle_yellow },
    ['@tag.delimiter'] = { fg = colors.subtle_green },
    ['@punctuation.delimiter'] = { fg = colors.subtle_green },
    ['@punctuation.bracket'] = { fg = colors.subtle_green },
    ['@punctuation.special'] = { fg = colors.subtle_pink },
    ['@comment'] = { fg = colors.comment_grey, italic = true },
    ['@operator'] = { fg = colors.fg_darker },
    ['@definition'] = { fg = colors.subtle_yellow, italic = true },

    -- lsp semantic token groups
    ['@lsp.type.class'] = { fg = colors.fg },
    ['@lsp.type.decorator'] = { fg = colors.subtle_pink },
    ['@lsp.type.enum'] = { fg = colors.fg },
    ['@lsp.type.function'] = { fg = colors.subtle_yellow, italic = true },
    ['@lsp.type.interface'] = { fg = colors.fg },
    ['@lsp.type.namespace'] = { fg = colors.fg },
    ['@lsp.type.parameter'] = { fg = colors.fg_darker },
    ['@lsp.type.property'] = { fg = colors.subtle_blue },
    ['@lsp.type.variable'] = { fg = colors.subtle_blue },
    ['@lsp.mod.callable'] = { fg = colors.subtle_yellow, italic = true },

    -- diagnostics
    DiagnosticError = { fg = colors.subtle_pink },
    DiagnosticWarn = { fg = colors.subtle_yellow },
    DiagnosticInfo = { fg = colors.subtle_blue },
    DiagnosticHint = { fg = colors.subtle_green },

    -- nvim-tree highlights
    NvimTreeFolderName = { fg = colors.fg_darker },
    NvimTreeOpenedFolderName = { fg = colors.fg_darker },
    NvimTreeEmptyFolderName = { fg = colors.fg_darker },
    NvimTreeFolderIcon = { fg = colors.fg_darker },
  }
end
