--- @class DynamicThemeKeymaps
--- @field create_color_page_keymaps fun(): nil
--- @field create_theme_page_keymaps fun(): nil
--- @field create_help_page_keymaps fun(): nil
local M = {}

--- clear all keymaps from the buffer
--- @return nil
local clear_buffer_keymaps = function()
  --- @type string[] list of keys to clear
  local keys_to_clear = {
    's',
    'r',
    't',
    'q',
    '?',
    'l',
    'n',
    'c',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  }
  for _, key in ipairs(keys_to_clear) do
    pcall(vim.api.nvim_buf_del_keymap, WINDOW_DATA.buf, 'n', key)
  end
end

--- @type table keymap options
local opts = { noremap = true, silent = true }

--- @return nil
M.create_color_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    's',
    ':DynamicThemeSave<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'r',
    ':DynamicThemeReset<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    't',
    ':DynamicThemeThemePage<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    '?',
    ':DynamicThemeHelpPage<CR>',
    opts
  )
end

--- @return nil
M.create_theme_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'l',
    ':DynamicThemeLoad<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'n',
    ':DynamicThemeRename<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'c',
    ':DynamicThemeColorPage<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    '?',
    ':DynamicThemeHelpPage<CR>',
    opts
  )

  local theme = require 'dynamic-theme.theme'
  for i = 1, 8 do
    vim.api.nvim_buf_set_keymap(WINDOW_DATA.buf, 'n', tostring(i), '', {
      noremap = true,
      silent = true,
      callback = function()
        theme.select_theme(i)
      end,
    })
  end
end

--- @return nil
M.create_help_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'c',
    ':DynamicThemeColorPage<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    't',
    ':DynamicThemeThemePage<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    opts
  )
end

return M
