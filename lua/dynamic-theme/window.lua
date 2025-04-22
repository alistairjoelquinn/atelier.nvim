local file = require 'dynamic-theme.file'
local theme = require 'dynamic-theme.theme'

local M = {}

---@class WindowData
---@field win number
---@field buf number

---@type WindowData
local window_data = {
  win = -1,
  buf = -1,
}

local input_fields = {}

local function extract_colors()
  local current_palette = file.read()
  local result = {}

  -- Group colors by category
  local categories = {
    ['Background Colors'] = { 'main_background', 'lighter_elements' },
    ['Foreground Colors'] = { 'main_text', 'secondary_text', 'emphasized_text' },
    ['Grey Colors'] = {
      'comments',
      'borders_linenumbers',
      'highlighted_elements',
    },
    ['Syntax/Semantic Colors'] = {
      'functions_warnings',
      'errors_special',
      'strings_success',
      'variables_identifiers',
      'types_classes',
    },
  }

  -- Create ordered list of colors with display names
  for category, color_keys in pairs(categories) do
    for _, key in ipairs(color_keys) do
      local hex = current_palette[key]
      if hex then
        table.insert(result, {
          category = category,
          name = key,
          hex = hex,
          path = key,
        })
      end
    end
  end

  return result
end

-- Apply updated colors to palette
local function update_palette()
  local current_palette = file.read()

  for _, field in ipairs(input_fields) do
    current_palette[field.path] = field.hex
  end

  file.write(current_palette)

  -- Apply theme updates by using the update function
  theme.update()
end

-- Validate hex color
local function validate_hex(hex)
  return hex:match '^#%x%x%x%x%x%x$' ~= nil
end

-- Create keymap for navigation and saving
local create_keymaps = function()
  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    's',
    '<cmd>lua require("dynamic-theme.window").save_changes()<CR>',
    { noremap = true, silent = true, desc = 'Save changes' }
  )

  -- Add field navigation keymaps
  vim.api.nvim_buf_set_keymap(
    window_data.buf,
    'n',
    '<CR>',
    '<cmd>lua require("dynamic-theme.window").edit_field()<CR>',
    { noremap = true, silent = true }
  )

  -- Set buffer local options
  vim.api.nvim_buf_set_option(window_data.buf, 'modifiable', true)
  vim.api.nvim_buf_set_option(window_data.buf, 'buftype', 'nofile')
end

-- Edit the field at cursor
M.edit_field = function()
  local line = vim.api.nvim_win_get_cursor(window_data.win)[1]

  -- Find the field at this line
  local field = nil
  for _, f in ipairs(input_fields) do
    if f.line == line then
      field = f
      break
    end
  end

  if field then
    -- Enter insert mode at the hex value position
    vim.api.nvim_win_set_cursor(window_data.win, { line, field.value_start })
    vim.cmd 'startinsert'
  end
end

-- Populate buffer with color inputs
local function populate_buffer()
  local lines = {
    'Dynamic Theme Color Editor',
    '========================',
    '',
    "Edit hex color values below. Press 's' to save changes, 'q' to quit.",
    '',
  }

  local colors = extract_colors()
  input_fields = {}

  local current_category = ''

  for i, color in ipairs(colors) do
    -- Add category header if new
    if color.category ~= current_category then
      if current_category ~= '' then
        table.insert(lines, '')
      end
      table.insert(lines, color.category:upper())
      table.insert(lines, string.rep('-', #color.category))
      current_category = color.category
    end

    -- Format display name
    local display_name = color.name:gsub('_', ' ')

    -- Add input line
    local input_line = string.format('  %s: %s', display_name, color.hex)
    table.insert(lines, input_line)

    -- Save field data
    table.insert(input_fields, {
      line = #lines,
      value_start = 4 + #display_name + 2,
      hex = color.hex,
      path = color.path,
    })
  end

  table.insert(lines, '')
  table.insert(lines, "Press 's' to save changes, 'q' to quit without saving")

  vim.api.nvim_buf_set_lines(window_data.buf, 0, -1, false, lines)

  -- Highlight hex colors
  for _, field in ipairs(input_fields) do
    vim.api.nvim_buf_add_highlight(
      window_data.buf,
      -1,
      'Special',
      field.line - 1,
      field.value_start - 1,
      field.value_start + 6
    )
  end
end

local create_window = function()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local config = {
    style = 'minimal',
    border = 'rounded',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
  }

  -- we always try and reuse the buffer from the previous open window, though
  -- always create a new window as the old window can't be reused
  if not vim.api.nvim_buf_is_valid(window_data.buf) then
    window_data.buf = vim.api.nvim_create_buf(false, true)
  end

  window_data.win = vim.api.nvim_open_win(window_data.buf, true, config)

  -- Set window-local options
  vim.api.nvim_win_set_option(window_data.win, 'wrap', false)
  vim.api.nvim_win_set_option(window_data.win, 'cursorline', true)
end

-- Read current values from buffer
local function read_current_values()
  for _, field in ipairs(input_fields) do
    local line = vim.api.nvim_buf_get_lines(
      window_data.buf,
      field.line - 1,
      field.line,
      false
    )[1]
    local value_part = line:sub(field.value_start)
    local hex_value = value_part:match '#%x%x%x%x%x%x'

    if hex_value and validate_hex(hex_value) then
      field.hex = hex_value
    end
  end
end

-- Save changes from input fields
M.save_changes = function()
  read_current_values()
  update_palette()
  vim.notify('Theme colors saved successfully!', vim.log.levels.INFO)
end

M.open_window = function()
  if not vim.api.nvim_win_is_valid(window_data.win) then
    create_window()
    create_keymaps()
    populate_buffer()
  end
end

M.close_window = function()
  if vim.api.nvim_win_is_valid(window_data.win) then
    vim.api.nvim_win_close(window_data.win, false)
  end
end

return M
