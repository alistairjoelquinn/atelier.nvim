---@class DynamicThemePalette
---@field ui table UI colors
---@field ui.bg table Background colors
---@field ui.bg.main_background string Main background color
---@field ui.bg.lighter_elements string Lighter background elements color
---@field ui.fg table Foreground colors
---@field ui.fg.main_text string Main text color
---@field ui.fg.secondary_text string Secondary text color
---@field ui.fg.emphasized_text string Emphasized text color
---@field ui.grey table Grey colors
---@field ui.grey.comments string Comments color
---@field ui.grey.borders_linenumbers string Borders and line numbers color
---@field ui.grey.highlighted_elements string Highlighted elements color
---@field syntax table Syntax colors
---@field syntax.functions_warnings string Functions and warnings color
---@field syntax.errors_special string Errors and special elements color
---@field syntax.strings_success string Strings and success indicators color
---@field syntax.variables_identifiers string Variables and identifiers color
---@field syntax.types_classes string Types and classes color

-- Color Palette Definition
---@return DynamicThemePalette
return {
  -- Base UI Colors
  ui = {
    bg = {
      main_background = '#1b1b20',
      lighter_elements = '#252830',
    },
    fg = {
      main_text = '#999999',
      secondary_text = '#777777',
      emphasized_text = '#aaaaaa',
    },
    grey = {
      comments = '#5a5a5a',
      borders_linenumbers = '#464646',
      highlighted_elements = '#565656',
    },
  },

  -- Semantic/Syntax Colors
  syntax = {
    functions_warnings = '#afa35b',
    errors_special = '#b77e89',
    strings_success = '#7a8574',
    variables_identifiers = '#7B8FA6',
    types_classes = '#8b7b8f',
  },
}
