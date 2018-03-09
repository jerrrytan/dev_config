autocmd!
set shell=/bin/zsh
"Vim command aliases
command Tidy !tidy -mi -xml -wrap 0 %

"Folding
set foldmethod=indent

"set colorcolumn=80
set cursorline "Highlight current line set incsearch "search as terms typed in
set wildmenu "visual autocomplete for command window
"highlight colorcolumn ctermbg=50

set nocompatible              " be iMproved, required filetype off                  " required

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

set nocursorline
set lazyredraw

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Call vim-plug to manage plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'w0rp/ale'
Plug 'Lokaltog/vim-easymotion'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-airline/vim-airline'
Plug 'klen/python-mode', {'branch': 'develop'}
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'lervag/vimtex'
Plug 'rust-lang/rust.vim'

"For prose
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-pencil'
Plug 'reedes/vim-wordy'

noremap <silent> <F8> :<C-u>NextWordy<cr>
let g:goyo_width=85

""autocmd! User GoyoEnter nested call <SID>GoyoBefore()
""autocmd! User GoyoLeave nested call <SID>GoyoAfter()
"let g:goyo_callbacks = [function('GoyoBefore'), function('GoyoAfter')]

let g:limelight_conceal_ctermfg = 'gray'
function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
  Limelight
  Pencil
endfunction

function! s:goyo_leave()
  " Quit Vim if this is the only remaining buffer
  Limelight!
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
  colorscheme gruvbox
  set background=dark
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()

call plug#end()

" filetype plugin indent on    " required
syntax on
set number
"autocmd BufNewFile,BufRead *.ys set ft=asm
"autocmd BufNewFile,BufRead *.ys set nosmartindent
"colorscheme Tomorrow-Night-Eighties
colorscheme gruvbox
set background=dark
set tabstop=4
set shiftwidth=4
set expandtab
autocmd BufWritePre * :%s/\s\+$//e

"Natural pane opening
set splitbelow
set splitright

if executable('ag')
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects
    ".gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    "ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

"For pymode
let g:pymode_rope = 0
let g:pymode_python = 'python3'
let g:pymode_lint_cwindow = 0

"Nvim options
if has('nvim')
  "let g:syntastic_mode_map = { 'mode': 'passive' }
  "map <F12> :SyntasticCheck <CR>
  map ¬ :vsplit <CR>
  map ˙ :vsplit <CR><bar><C-w><C-h><CR>
  map ∆ :split <CR>
  map ˚ :split <CR><bar><C-w><C-k><CR>
  map <C-s> :terminal <CR>
  map <D-s> :cd %:p:h <CR>

  set tabstop=2
  set shiftwidth=2

  tnoremap <Esc> <C-\><C-n>
  "set shell=/usr/bin/fish
  "set shell=/usr/bin/bash
  set clipboard+=unnamedplus
endif

let g:vimtex_view_method="mupdf"

"For starting neomake automatically
"" When writing a buffer.
"call neomake#configure#automake('w')
"" When writing a buffer, and on normal mode changes (after 750ms).
"call neomake#configure#automake('nw', 750)
"" When reading a buffer (after 1s), and when writing.
"call neomake#configure#automake('rw', 1000)

"let g:neomake_cpp_enable_markers=['clang']
"let g:neomake_cpp_clang_args = ["-std=c++14", "-Wextra", "-Wall", "-fsanitize=undefined","-g"]
"" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

"Only lint on saves
let g:ale_lint_on_text_changed = 'never'

"let g:ale_cpp_clang_options='-std=c++14 -Wall -Wextra -Iinclude -I../include'
"let g:ale_cpp_gcc_options='-std=c++14 -Wall -Wextra -Iinclude -I../include'
"let g:ale_cpp_gcc_options='-std=c++14 -Wall -Wextra'
"Control k and control j to navigate to previous and next ALE errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
