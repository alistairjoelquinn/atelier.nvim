--- @class AtelierKeymaps
--- @field create_color_page_keymaps fun(): nil
--- @field create_colorscheme_page_keymaps fun(): nil
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
    'e',
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
    ':AtelierSave<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'r',
    ':AtelierReset<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'l',
    ':AtelierLibrary<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'q',
    ':AtelierClose<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    '<Esc>',
    ':AtelierClose<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    '?',
    ':AtelierHelpPage<CR>',
    opts
  )
end

--- @return nil
M.create_colorscheme_page_keymaps = function()
  -- first clear any potentially existing keymaps
  clear_buffer_keymaps()

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'l',
    ':AtelierLoad<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'n',
    ':AtelierRename<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'c',
    ':AtelierColorPage<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'q',
    ':AtelierClose<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    '<Esc>',
    ':AtelierClose<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    '?',
    ':AtelierHelpPage<CR>',
    opts
  )

  for i = 1, 8 do
    -- colorscheme selection keymaps
    vim.api.nvim_buf_set_keymap(WINDOW_DATA.buf, 'n', tostring(i), '', {
      noremap = true,
      silent = true,
      callback = function()
        local colorscheme = require 'atelier.colorscheme'
        colorscheme.select_colorscheme(i)
      end,
    })

    -- export colorscheme keymaps, using 'e' followed by a colorscheme number
    vim.api.nvim_buf_set_keymap(WINDOW_DATA.buf, 'n', 'e' .. tostring(i), '', {
      noremap = true,
      silent = true,
      callback = function()
        local export = require 'atelier.export'
        export.export_colorscheme(i)
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
    ':AtelierColorPage<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    't',
    ':AtelierColorschemePage<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    'q',
    ':AtelierClose<CR>',
    opts
  )

  vim.api.nvim_buf_set_keymap(
    WINDOW_DATA.buf,
    'n',
    '<Esc>',
    ':AtelierClose<CR>',
    opts
  )
end

return M
