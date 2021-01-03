" Install vim-plug if not found
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin()

" Plugin list
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'alvan/vim-closetag'
" Language support
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'plasticboy/vim-markdown'
Plug 'dart-lang/dart-vim-plugin'
Plug 'evanleck/vim-svelte'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
" Theme
Plug 'ntk148v/vim-horizon'

call plug#end()

" COC extensions
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-html', 'coc-rust-analyzer', 'coc-emmet', 'coc-tsserver']

" Settings
syntax on
set expandtab
set shiftwidth=2
set autoindent
set smartindent
set tabstop=2
set number
set mouse=a
set ignorecase
set smartcase
set laststatus=2
set showtabline=2
set noshowmode
set nowrap
set formatoptions-=cro
filetype plugin on
autocmd BufRead,BufNewFile *.md setlocal spell wrap linebreak

" NeoVide Settings
let g:neovide_refresh_rate=60
let g:neovide_transparency=1.0
let g:neovide_no_idle=v:false
let g:neovide_fullscreen=v:false
let g:neovide_cursor_animation_length=0.0
let g:neovide_cursor_trail_length=0.0
let g:neovide_cursor_antialiasing=v:true
set guifont=FiraCode\ Nerd\ Font:h21

" color stuff
set termguicolors
colorscheme horizon
execute "set t_8f=\e[38;2;%lu;%lu;%lum"
execute "set t_8b=\e[48;2;%lu;%lu;%lum"

" Keybindings
nmap <silent> <C-b> :NERDTreeToggle<CR>
nmap <silent> <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <silent> <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <silent> <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <silent> <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <silent> <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <silent> <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <silent> <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <silent> <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <silent> <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <silent> <Leader>0 <Plug>lightline#bufferline#go(10)
nmap <silent> <C-w> :bd<CR>
nnoremap <silent> <C-s> :w<CR>
inoremap <silent> <C-s> <Esc> :w<CR>
vnoremap <silent> <C-s> <Esc> :w<CR>
vnoremap <silent> <C-X> "+x
vnoremap <silent> <C-C> "+y
map <silent> <C-V> "+gP
inoremap <silent> <C-V> <Esc> "+gP<CR>
nmap <silent> <C-/> <plug>NERDCommenterToggle
xmap <silent> <C-/> <plug>NERDCommenterToggle
nnoremap <silent> <C-f> :Rg<CR>

" Custom commands
command! Settings :e $MYVIMRC
command! Reload :so $MYVIMRC

" Plugin Configurations
let g:lightline                  = {}
let g:lightline.colorscheme = 'horizon'
let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'
let NERDTreeShowHidden = 1
let g:lsc_auto_map = v:true
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.md,*.svelte'
let g:coc_disable_startup_warning = 1

" Lightline update
autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

" coc.nvim configuration
" ---
" Configuration is required to make coc.nvim easier to work
" with, since it doesn't change your key-mappings or Vim options.
" This is done as much as possible to avoid conflict with your other plugins.
" ---

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <TAB> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add `Prettier command to format current buffer`
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
 
