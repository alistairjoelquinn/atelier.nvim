---@class DynamicThemePalette
---@field main_background string Main background color
---@field lighter_elements string Lighter background elements color
---@field main_text string Main text color
---@field secondary_text string Secondary text color
---@field emphasized_text string Emphasized text color
---@field comments string Comments color
---@field borders_linenumbers string Borders and line numbers color
---@field highlighted_elements string Highlighted elements color
---@field functions_warnings string Functions and warnings color
---@field errors_special string Errors and special elements color
---@field strings_success string Strings and success indicators color
---@field variables_identifiers string Variables and identifiers color
---@field types_classes string Types and classes color

-- Color Palette Definition
---@return DynamicThemePalette
return {
  -- Background colors
  main_background = '#1b1b20',
  lighter_background = '#252830',

  -- Foreground colors
  main_text = '#999999',
  secondary_text = '#777777',
  emphasized_text = '#aaaaaa',

  -- Grey colors
  comments = '#5a5a5a',
  borders_and_linenumbers = '#464646',
  highlighted_elements = '#565656',

  -- Semantic/Syntax Colors
  functions_and_warnings = '#afa35b',
  errors_and_special_characters = '#b77e89',
  strings_and_success = '#7a8574',
  variables_and_identifiers = '#7B8FA6',
  types_and_classes = '#8b7b8f',
}
