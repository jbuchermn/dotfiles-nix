" Basic {{{
" Settings
set encoding=utf8
set mouse=a
set so=999 " Keep cursor centered vertically
set number
set hidden

set autoindent
set smartindent

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

set splitbelow
set splitright

syntax enable

" Theming
colorscheme OceanicNext

if (has("termguicolors"))
 set termguicolors
endif

" }}}

" Behaviour {{{
" Remember cursor position between sessions
autocmd BufReadPost *
            \ if line("'\"") > 0 && line ("'\"") <= line("$") |
            \   exe "normal! g'\"" |
            \ endif

" Save undos
set undodir=~/.config/nvim/undodir
set undofile

" Folding
set foldmethod=syntax
set foldlevelstart=20

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup end
" }}}

" Key bindings {{{
" Leader
let mapleader = " "
nnoremap <Space> <nop>

" Easier to reach
nmap ö :
vmap ö :

" Clear highlights
nmap <silent> <ESC> :noh<CR>

" Highlight without jumping
nnoremap * *N 

" Change word under cursor and repeat with dot operator (or n. to preview)
nnoremap c* *Ncgn

" Map arrow keys
nmap <silent> <Up> :lprevious<CR>
nmap <silent> <Down> :lnext<CR>
nmap <silent> <S-Up> :cprevious<CR>
nmap <silent> <S-Down> :cnext<CR>

vmap <Up> <Nop>
vmap <Down> <Nop>

nmap <Left> <<
nmap <Right> >>
vmap <Left> <gv
vmap <Right> >gv

" Toggle comments
let g:tcomment_maps = 0
nnoremap <silent> <leader>cc :TComment<CR>
vnoremap <silent> <leader>cc :TComment<CR>
vnoremap <silent> <leader>ci :TCommentInline<CR>

" }}}
