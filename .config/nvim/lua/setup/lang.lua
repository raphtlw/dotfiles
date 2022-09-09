-- Language-specific tooling configurations and setup

local has_cmp, cmp = pcall(require, 'cmp')
if not has_cmp then return end

local has_lsp, lsp = pcall(require, 'lspconfig')
if not has_lsp then return end

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local auclear = vim.api.nvim_clear_autocmds -- Clear autocommands (used to prevent duplication when reloading configs)

local map = require('lib').map -- Set keymap to a function or vim action

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({ name = 'DiagnosticSignError', text = '✘' })
sign({ name = 'DiagnosticSignWarn',  text = '▲' })
sign({ name = 'DiagnosticSignHint',  text = '⚑' })
sign({ name = 'DiagnosticSignInfo',  text = '' })

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Reused LSP on_attach functions
local format_on_save = function(client, bufnr)
  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('Format', { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.formatting_seq_sync() end
    })
  end
end

local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
  end
}
lsp.util.default_config = vim.tbl_deep_extend('force', lsp.util.default_config, lsp_defaults)

-- TypeScript
lsp.tsserver.setup {
  capabilities = capabilities,
  on_attach = function(...)
    format_on_save(...)
    lsp.util.default_config.on_attach(...)
  end,
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  cmd = { 'typescript-language-server', '--stdio' },
}

-- Rust
require('rust-tools').setup {
  server = {
    capabilities = capabilities,
    on_attach = function(...)
      lsp.util.default_config.on_attach(...)
    end,
  }
}

-- Lua
lsp.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = function(...)
    lsp.util.default_config.on_attach(...)
  end,
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
  single_file_support = true,
}

-- LSP attached configuration
autocmd('User', {
  pattern = 'LspAttached',
  desc = 'LSP actions',
  callback = function()
    -- Displays hover information about the symbol under the cursor
    map('n', 'K', function()
      vim.lsp.buf.hover()
    end)

    -- Jump to the definition
    map('n', 'gd', function()
      vim.lsp.buf.definition()
    end)

    -- Jump to the declaration
    map('n', 'gD', function()
      vim.lsp.buf.declaration()
    end)

    -- Lists all the implementations for the symbol under the cursor
    map('n', 'gi', function()
      vim.lsp.buf.implementation()
    end)

    -- Jumps to the definition of the type symbol
    map('n', 'go', function()
      vim.lsp.buf.type_definition()
    end)

    -- Lists all the references
    map('n', 'gr', function()
      vim.lsp.buf.references()
    end)

    -- Displays a function's signature information
    map('n', '<C-k>', function()
      vim.lsp.buf.signature_help()
    end)

    -- Renames all references to the symbol under the cursor
    map('n', '<F2>', function()
      vim.lsp.buf.rename()
    end)

    -- Selects a code action available at the current cursor position
    map('n', '<F4>', function()
      vim.lsp.buf.code_action()
    end)
    map('x', '<F4>', function()
      vim.lsp.buf.range_code_action()
    end)

    -- Show diagnostics in a floating window
    map('n', 'gl', function()
      vim.diagnostic.open_float()
    end)

    -- Move to the previous diagnostic
    map('n', '[d', function()
      vim.diagnostic.goto_prev()
    end)

    -- Move to the next diagnostic
    map('n', ']d', function()
      vim.diagnostic.goto_next()
    end)
  end
})

require('luasnip.loaders.from_vscode').lazy_load()

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)
