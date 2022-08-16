-- catppuccin: https://github.com/catppuccin/nvim

local has_catppuccin, catppuccin = pcall(require, 'catppuccin')
if not has_catppuccin then return end

vim.g.catppuccin_flavour = 'mocha' -- latte, frappe, macchiato, mocha

catppuccin.setup {}

vim.cmd [[colorscheme catppuccin]]
