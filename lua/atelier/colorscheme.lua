--- @type AtelierPalette
local palette = require 'atelier.palette'
local file = require 'atelier.file'
local utils = require 'atelier.utils'

--- @type Colorscheme[]
local defaultColorschemeList = {
  { name = 'dull-ish', selected = true, palette = palette },
  { name = '<EMPTY>', selected = false, palette = nil },
  { name = '<EMPTY>', selected = false, palette = nil },
  { name = '<EMPTY>', selected = false, palette = nil },
  { name = '<EMPTY>', selected = false, palette = nil },
  { name = '<EMPTY>', selected = false, palette = nil },
  { name = '<EMPTY>', selected = false, palette = nil },
  { name = '<EMPTY>', selected = false, palette = nil },
}

--- palette for empty colorschemes before the user applies their own colors
--- @type AtelierPalette
local default_grey_palette = {
  main_background = '#010101',
  current_line_highlight = '#252830',
  keywords_and_delimiters = '#999999',
  numbers_and_math_symbols = '#777777',
  emphasized_text = '#aaaaaa',
  comments = '#5a5a5a',
  borders_and_line_numbers = '#464646',
  search_highlight_background = '#565656',
  visual_highlight_background = '#3a3a4a',
  functions_and_warnings = '#888888',
  errors_scope_and_special_characters = '#777777',
  strings_and_success = '#666666',
  variables_and_identifiers = '#555555',
  types_and_classes = '#444444',
}

--- @class AtelierColorscheme
--- @field initialize_palette fun(): AtelierPalette|nil
--- @field reset fun(): nil
--- @field apply fun(): nil
--- @field select_colorscheme fun(new_index: number): nil
--- @field create_highlight_groups fun(colors: AtelierPalette): table<string, table>
local M = {}

--- initialize the palette from file or create default if none exists
--- @return AtelierPalette|nil
M.initialize_palette = function()
  if not file.exists() then
    file.write(defaultColorschemeList)
  end

  local loaded_file = file.read()
  if not loaded_file then
    vim.notify('Error loading colorscheme', vim.log.levels.ERROR)
    return nil
  end

  local selected_colorscheme = utils.findSelectedColorscheme(loaded_file)
  if not selected_colorscheme then
    vim.notify('No selected colorscheme detected', vim.log.levels.ERROR)
    return nil
  end

  return selected_colorscheme.palette
end

--- reset to plugin defaults
M.reset = function()
  local choice = vim.fn.confirm(
    'WARNING: This will reset all colorschemes to factory defaults. All custom colorschemes will be lost!',
    '&Reset\n&Cancel',
    2, -- Default to Cancel
    'Warning'
  )

  if choice == 1 then
    file.write(defaultColorschemeList)
    M.apply()

    -- reload the window content
    if WINDOW_DATA and vim.api.nvim_win_is_valid(WINDOW_DATA.win) then
      local page = require 'atelier.page'
      page.load_color_page()
    end
  end
end

--- update the colorscheme with updated current palette values
M.apply = function()
  local loaded_palette = M.initialize_palette()
  if not loaded_palette then
    vim.notify('Error initializing palette', vim.log.levels.ERROR)
    return
  end

  local highlight_groups = M.create_highlight_groups(loaded_palette)

  for group, settings in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

--- select a colorscheme by index
--- @param new_index number the index of the colorscheme to select
M.select_colorscheme = function(new_index)
  local colorscheme_list = file.read()
  if not colorscheme_list or new_index < 1 or new_index > #colorscheme_list then
    return
  end

  local _, current_index = utils.findSelectedColorscheme(colorscheme_list)
  if current_index then
    if current_index == new_index then
      -- if the user tries to re-select the current colorscheme, do nothing
      return
    else
      -- otherwise persist that the old colorscheme is no longer selected
      colorscheme_list[current_index].selected = false
    end
  end

  local new_colorscheme = colorscheme_list[new_index]

  -- if the colorscheme is empty, prompt for a name and initialize it
  if new_colorscheme.name == '<EMPTY>' then
    local new_name = vim.fn.input 'Enter name for new colorscheme: '
    if new_name and new_name ~= '' then
      if #new_name > 16 then
        vim.cmd 'echohl ErrorMsg | echom "Colorscheme name must be less than 16 characters" | echohl None'
        vim.cmd 'call getchar()' --  user must acknowledge error before proceeding
        return
      end
      new_colorscheme.name = new_name
      new_colorscheme.palette = default_grey_palette
    else
      vim.notify('Colorscheme creation cancelled', vim.log.levels.INFO)
      return
    end
  end

  -- ensure the colorscheme has a palette
  if not new_colorscheme.palette then
    new_colorscheme.palette = default_grey_palette
    vim.notify(
      'Palette not detected. Initialised colorscheme with default grey palette',
      vim.log.levels.WARN
    )
  end

  -- always mark the new colorscheme as selected
  new_colorscheme.selected = true

  -- persist new values and update
  file.write(colorscheme_list)
  M.apply()

  -- return to the color page for the newly selected colorscheme
  local page = require 'atelier.page'
  page.show_color_page()
end

--- create highlight groups based on colors
--- @param colors AtelierPalette the color palette to use
--- @return table<string, table> highlight groups with their settings
M.create_highlight_groups = function(colors)
  return {
    -- Core editor elements
    Normal = {
      fg = colors.keywords_and_delimiters,
      bg = colors.main_background,
    },
    NormalFloat = {
      fg = colors.keywords_and_delimiters,
      bg = colors.main_background,
    },
    Cursor = {
      fg = colors.main_background,
      bg = colors.keywords_and_delimiters,
    },
    CursorLine = { bg = colors.current_line_highlight },
    LineNr = { fg = colors.borders_and_line_numbers },
    CursorLineNr = { fg = colors.functions_and_warnings },
    SignColumn = { bg = colors.main_background },

    -- Window elements
    WinSeparator = { fg = colors.borders_and_line_numbers },
    FloatBorder = { fg = colors.borders_and_line_numbers },

    -- Popup menus
    Pmenu = {
      fg = colors.keywords_and_delimiters,
      bg = colors.current_line_highlight,
    },
    PmenuSel = {
      fg = colors.emphasized_text,
      bg = colors.borders_and_line_numbers,
    },
    PmenuSbar = { bg = colors.current_line_highlight },
    PmenuThumb = { bg = colors.borders_and_line_numbers },

    -- Search highlighting
    Search = {
      fg = colors.emphasized_text,
      bg = colors.search_highlight_background,
    },
    IncSearch = {
      fg = colors.emphasized_text,
      bg = colors.search_highlight_background,
    },
    CurSearch = {
      fg = colors.emphasized_text,
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
    Number = { fg = colors.numbers_and_math_symbols },
    Function = { fg = colors.functions_and_warnings, italic = true },
    Keyword = { fg = colors.keywords_and_delimiters },
    Constant = { fg = colors.errors_scope_and_special_characters },
    Type = { fg = colors.types_and_classes },
    Statement = { fg = colors.keywords_and_delimiters },
    Special = { fg = colors.errors_scope_and_special_characters },
    Identifier = { fg = colors.variables_and_identifiers },
    PreProc = { fg = colors.keywords_and_delimiters },
    Delimiter = { fg = colors.keywords_and_delimiters },
    Operator = { fg = colors.numbers_and_math_symbols },
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
    ['@tag.delimiter'] = { fg = colors.keywords_and_delimiters },
    ['@punctuation.delimiter'] = { fg = colors.keywords_and_delimiters },
    ['@punctuation.bracket'] = { fg = colors.keywords_and_delimiters },
    ['@punctuation.special'] = {
      fg = colors.errors_scope_and_special_characters,
    },
    ['@comment'] = { fg = colors.comments, italic = true },
    ['@operator'] = { fg = colors.numbers_and_math_symbols },
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
    ['@lsp.type.parameter'] = { fg = colors.numbers_and_math_symbols },
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
    NvimTreeFolderName = { fg = colors.numbers_and_math_symbols },
    NvimTreeOpenedFolderName = { fg = colors.numbers_and_math_symbols },
    NvimTreeEmptyFolderName = { fg = colors.numbers_and_math_symbols },
    NvimTreeFolderIcon = { fg = colors.numbers_and_math_symbols },
  }
end

return M
