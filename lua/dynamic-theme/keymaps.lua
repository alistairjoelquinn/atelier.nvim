local M = {}

local clear_buffer_keymaps = function()
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

M.create_color_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    's',
    ':DynamicThemeSave<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'r',
    ':DynamicThemeReset<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    't',
    ':DynamicThemeThemePage<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    '?',
    ':DynamicThemeHelpPage<CR>',
    { noremap = true, silent = true }
  )
end

M.create_theme_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'l',
    ':DynamicThemeLoad<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'n',
    ':DynamicThemeRename<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'c',
    ':DynamicThemeColorPage<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    '?',
    ':DynamicThemeHelpPage<CR>',
    { noremap = true, silent = true }
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

M.create_help_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'c',
    ':DynamicThemeColorPage<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    't',
    ':DynamicThemeThemePage<CR>',
    { noremap = true, silent = true }
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'q',
    ':DynamicThemeClose<CR>',
    { noremap = true, silent = true }
  )
end

return M
