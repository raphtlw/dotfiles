-- nvim-lspconfig: https://github.com/neovim/nvim-lspconfig

local has_lspconfig, lsp = pcall(require, 'lspconfig')
if not has_lspconfig then return end

-- Give me rounded borders everywhere
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
