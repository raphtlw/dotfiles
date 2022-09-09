-----------------------------------------------
-- General Neovim settings and configuration --
-----------------------------------------------

local cmd = vim.cmd
local api = vim.api

local options = {
  backup = false,                                  -- creates a backup file
  clipboard = 'unnamedplus',                       -- allows neovim to access the system clipboard
  cmdheight = 2,                                   -- more space in the neovim command line for displaying messages
  completeopt = { 'menu', 'menuone', 'noselect' }, -- mostly just for cmp
  conceallevel = 0,                                -- so that `` is visible in markdown files
  fileencoding = 'utf-8',                          -- the encoding written to a file
  hlsearch = true,                                 -- highlight all matches on previous search pattern
  ignorecase = true,                               -- ignore case in search patterns
  mouse = 'a',                                     -- allow the mouse to be used in neovim
  pumheight = 10,                                  -- pop up menu height
  showtabline = 2,                                 -- always show tabs
  smartcase = true,                                -- smart case
  smartindent = true,                              -- make indenting smarter again
  splitbelow = true,                               -- force all horizontal splits to go below current window
  splitright = true,                               -- force all vertical splits to go to the right of current window
  swapfile = false,                                -- creates a swapfile
  termguicolors = true,                            -- set term gui colors (most terminals support this)
  timeoutlen = 100,                                -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                                 -- enable persistent undo
  updatetime = 300,                                -- faster completion (4000ms default)
  writebackup = false,                             -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                                -- convert tabs to spaces
  shiftwidth = 2,                                  -- the number of spaces inserted for each indentation
  tabstop = 2,                                     -- insert 2 spaces for a tab
  cursorline = true,                               -- highlight the current line
  number = true,                                   -- set numbered lines
  relativenumber = false,                          -- set relative numbered lines
  numberwidth = 4,                                 -- set number column width to 2 {default 4}
  signcolumn = 'yes',                              -- always show the sign column, otherwise it would shift the text each time
  wrap = false,                                    -- display lines as one long line
  scrolloff = 999,                                 -- make cursor centered always
  sidescrolloff = 8,
  guifont = 'FiraCode Nerd Font Mono:h14',         -- the font used in graphical neovim applications
  background = 'dark'                              -- tells the theme which variant to use
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

cmd 'set iskeyword+=-'
