--- @class DynamicThemePalette
--- @field main_background string main background color
--- @field current_line_highlight string current line highlight color
--- @field keywords_and_delimiters string keyword color
--- @field numbers_and_math_symbols string numbers and math symbols color
--- @field emphasized_text string emphasized text color (search results / focused list items)
--- @field comments string comments color
--- @field borders_and_line_numbers string borders and line numbers color
--- @field search_highlight_background string search highlight background color
--- @field visual_highlight_background string visual mode highlight background color
--- @field functions_and_warnings string functions and warnings color
--- @field errors_scope_and_special_characters string errors, scope and special elements color
--- @field strings_and_success string strings and success indicators color
--- @field variables_and_identifiers string variables and identifiers color
--- @field types_and_classes string types and classes color

-- color palette definition
--- @return DynamicThemePalette the default color palette
return {
  -- background colors
  main_background = '#1b1b20',
  current_line_highlight = '#252830',

  -- foreground colors
  keywords_and_delimiters = '#999999',
  numbers_and_math_symbols = '#777777',
  emphasized_text = '#aaaaaa',

  -- grey colors
  comments = '#5a5a5a',
  borders_and_line_numbers = '#464646',
  search_highlight_background = '#565656',
  visual_highlight_background = '#3a3a4a',

  -- semantic/syntax colors
  functions_and_warnings = '#afa35b',
  errors_scope_and_special_characters = '#b77e89',
  strings_and_success = '#7a8574',
  variables_and_identifiers = '#7B8FA6',
  types_and_classes = '#8b7b8f',
}
