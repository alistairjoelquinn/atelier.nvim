local atelier = require 'atelier.init'

vim.api.nvim_command 'hi clear'

if vim.fn.exists 'syntax_on' then
  vim.api.nvim_command 'syntax reset'
end

vim.o.termguicolors = true
vim.g.colors_name = 'atelier'

atelier.setup()
