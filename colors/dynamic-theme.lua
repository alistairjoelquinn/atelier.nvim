local dynamic_theme = require 'dynamic-theme'

vim.api.nvim_command 'hi clear'

if vim.fn.exists 'syntax_on' then
  vim.api.nvim_command 'syntax reset'
end

vim.o.termguicolors = true
vim.g.colors_name = 'dynamic-theme'

return dynamic_theme
