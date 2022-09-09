-- mason.nvim: https://github.com/williamboman/mason.nvim

local has_mason, mason = pcall(require, 'mason')
if not has_mason then return end

local has_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not has_mason_lspconfig then return end

mason.setup()
mason_lspconfig.setup()
