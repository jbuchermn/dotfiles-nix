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

set list
set listchars=tab:▸\ ,trail:·

set updatetime=100 " necessary e.g. for vim-gitgutter

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

nmap <Left> <<
nmap <Right> >>
vmap <Left> <gv
vmap <Right> >gv


" Prevent accidental command history buffer
nnoremap q: <nop>
nnoremap Q <nop>

" }}}

" Plugins {{{
let g:tcomment_maps = 0
nnoremap <silent> <leader>cc :TComment<CR>
vnoremap <silent> <leader>cc :TComment<CR>
vnoremap <silent> <leader>ci :TCommentInline<CR>

nnoremap <expr> - g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'

nnoremap <silent> <Up> :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <Down> :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> <leader>cF :Lspsaga lsp_finder<CR>
nnoremap <silent> <leader>cP :Lspsaga preview_definition<CR>

nnoremap <silent> <leader>pf <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <silent> <leader>pb <cmd>lua require('telescope.builtin').file_browser()<CR>
nnoremap <silent> <leader>/ <cmd>lua require('telescope.builtin').live_grep()<CR>

nnoremap <silent> <leader>gg :Git<CR>
" }}}
