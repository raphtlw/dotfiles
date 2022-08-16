------------------------------
-- Editor keyboard mappings --
------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }  -- Default options
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  if type(rhs) == 'string' then
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  elseif type(rhs) == 'function' then
    vim.keymap.set(mode, lhs, rhs, options)
  else
    error('Invalid call to map()')
  end
end

-- Leader key
vim.g.mapleader = '\\'

-- Terminal mappings
map('n', '<C-t>', '<CMD>terminal<CR>')  -- open
map('t', '<Esc>', '<C-\\><C-n>')        -- exit

-- Telescope
map('n', '<C-p>', function()
  require('telescope.builtin').find_files()
end)
map('n', '<C-;>', function()
  require('telescope.builtin').commands()
end)

-- NvimTree
map('n', '<A-e>', '<CMD>NvimTreeToggle<CR>')
map('n', '<Leader>r', '<CMD>NvimTreeRefresh<CR>')

-- Bufferline
map('n', '<A-,>', '<CMD>BufferPrevious<CR>')
map('n', '<A-.>', '<CMD>BufferNext<CR>')
map('n', '<A-<>', '<CMD>BufferMovePrevious<CR>')
map('n', '<A->>', '<CMD>BufferMoveNext<CR>')
-- Jump to buffer by index
map('n', '<A-1>', '<CMD>BufferGoto 1<CR>')
map('n', '<A-2>', '<CMD>BufferGoto 2<CR>')
map('n', '<A-3>', '<CMD>BufferGoto 3<CR>')
map('n', '<A-4>', '<CMD>BufferGoto 4<CR>')
map('n', '<A-5>', '<CMD>BufferGoto 5<CR>')
map('n', '<A-6>', '<CMD>BufferGoto 6<CR>')
map('n', '<A-7>', '<CMD>BufferGoto 7<CR>')
map('n', '<A-8>', '<CMD>BufferGoto 8<CR>')
map('n', '<A-9>', '<CMD>BufferGoto 9<CR>')
map('n', '<A-0>', '<CMD>BufferLast<CR>')
-- Close buffer
map('n', '<A-c>', '<CMD>BufferClose<CR>')

-- Easier split mappings
map("n", "<Leader><Down>", "<C-W><C-J>")
map("n", "<Leader><Up>", "<C-W><C-K>")
map("n", "<Leader><Right>", "<C-W><C-L>")
map("n", "<Leader><Left>", "<C-W><C-H>")
map("n", "<Leader>;", "<C-W>R")
map("n", "<Leader>[", "<C-W>_")
map("n", "<Leader>]", "<C-W>|")
map("n", "<Leader>=", "<C-W>=")

-- Option + Backspace deletes whole words in OSX/Kitty.
-- Requires `macos_option_as_alt yes` to be set in Kitty config.
map("i", "<A-BS>", "<C-W>")

-- After searching, pressing escape stops the highlight
map('n', '<ESC>', '<CMD>noh<CR>')
