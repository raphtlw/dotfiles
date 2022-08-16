---------------------------
-- Autocommand functions --
---------------------------

local cmd = vim.cmd
local api = vim.api

local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local auclear = vim.api.nvim_clear_autocmds -- Clear autocommands (used to prevent duplication when reloading configs)

augroup('user', { clear = true })

-- Reload config when any of the files are saved
autocmd({'BufWritePost'}, {
  pattern = {'*/.config/nvim/*.lua'},
  group = 'user',
  callback = function()
    cmd 'luafile <afile>'
    print '⚙️ Config reloaded'
  end,
})

-- Turn on word wrapping for set filetypes
autocmd({'BufRead', 'BufNewFile'}, {
  pattern = {'*.md'},
  group = 'user',
  command = 'setlocal spell wrap linebreak',
})

-- Don't auto comment new lines
autocmd({'BufEnter'}, {
  pattern = '*',
  group = 'user',
  command = 'setlocal formatoptions-=cro',
})

-- Highlight on yank
autocmd('TextYankPost', {
  group = 'user',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '1000' })
  end,
})

-- Filetype specific settings:
--

-- Enter insert mode when switching to terminal
autocmd('TermOpen', {
  group = 'user',
  command = 'setlocal listchars= nonumber norelativenumber nocursorline',
})
autocmd('TermOpen', {
  pattern = '*',
  group = 'user',
  command = 'startinsert',
})

-- Close terminal buffer on process exit
autocmd('BufLeave', {
  pattern = 'term://*',
  command = 'stopinsert',
})

-- Show cursor line only in active window
autocmd({'InsertLeave', 'WinEnter'}, {
  pattern = '*',
  group = 'user',
  command = 'set cursorline',
})
autocmd({'InsertEnter', 'WinLeave'}, {
  pattern = '*',
  group = 'user',
  command = 'set nocursorline',
})
