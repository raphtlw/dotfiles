syntax on

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Plugin list
Plug 'jiangmiao/auto-pairs'
Plug 'ervandew/supertab'
Plug 'ycm-core/YouCompleteMe'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'

call plug#end()

set expandtab
set shiftwidth=2
set autoindent
set smartindent
set tabstop=2
set number
set statusline=%f
set mouse=a
set ignorecase
set smartcase

map <C-n> :NERDTreeToggle<CR>
