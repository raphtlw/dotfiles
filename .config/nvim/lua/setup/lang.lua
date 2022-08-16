-- Language-specific tooling configurations and setup

local has_cmp, cmp = pcall(require, 'cmp')
if not has_cmp then return end

local has_lsp, lsp = pcall(require, 'lspconfig')
if not has_lsp then return end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Reused LSP on_attach functions
local format_on_save = function(client, buf)
  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('Format', { clear = true }),
      buffer = buf,
      callback = function() vim.lsp.buf.formatting_seq_sync() end
    })
  end
end

-- TypeScript
lsp.tsserver.setup {
  capabilities = capabilities,
  on_attach = function(...)
    format_on_save(...)
  end,
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  cmd = { 'typescript-language-server', '--stdio' },
}

-- Rust
require('rust-tools').setup {
  server = {
    capabilities = capabilities,
    on_attach = function(client, buf) end,
  }
}

-- Lua
lsp.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = function(client, buf) end,
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
      completion = { enable = true, callSnippet = 'Both' },
      diagnostics = {
        enable = true,
        globals = { 'vim', 'describe' },
        disable = { 'lowercase-global' },
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
        -- Performance tweaks
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
    },
  },
}
