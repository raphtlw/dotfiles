" ~/.vimrc
" Plain vim configuration for performing light editing tasks with vim.

" Settings
syntax on
set expandtab
set shiftwidth=2
set tabstop=2
set number
set mouse=a
set ignorecase
set smartcase
set laststatus=2
set showtabline=2
set noshowmode
set nowrap
set cursorline
set autoindent
set so=999
filetype plugin on
filetype plugin indent on
autocmd BufRead,BufNewFile *.md setlocal spell wrap linebreak
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

" Use line cursor within insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
