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

nnoremap <expr> - g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'

lua << EOF
-- nvim-lspconfig
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<Up>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<Down>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>cD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>cd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>cR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>ci', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>ct', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

nvim_lsp.ccls.setup {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    }
}
-- This workaround is necessary, as for some reasen typescript-language-server does not list typescript as a dependency (?!)
local handle = io.popen("/usr/bin/env which tsserver")
local tsserver = handle:read("*a")
tsserver = string.gsub(tsserver, "\n", "")
handle:close()
-- print("Found tsserver at '" .. tsserver .. "'")

nvim_lsp.tsserver.setup {
    cmd = { "typescript-language-server", "--stdio", "--tsserver-path", tsserver},
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    }
}
nvim_lsp.ccls.setup {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    }
}

-- Try and setup proper python environment based on heuristics:
-- if there is a flake.nix containing python-lsp-server, we assume "nix devlop" puts us in a proper development environment containing all dependencies and pylsp
local handle = io.popen("cat flake.nix | grep 'python-lsp-server'")
local grep_res = handle:read("*a")
local assume_dev = string.find(grep_res, "lsp")
handle:close()
if(assume_dev) then print("Assuming development environment (nix develop) is set up containing pylsp...") end

nvim_lsp.pylsp.setup {
    cmd = assume_dev and { "nix", "develop", "--command", "python3", "-m", "pylsp" } or
        { "nvim-python3", "-m", "pylsp", "-vv", "--log-file", "/tmp/pylsp.log" },
    flags = {
        debounce_text_changes = 150,
    },
    on_attach = on_attach,
    settings = {
      pylsp = {
        plugins = {
            pycodestyle = { enabled = false },
            mccabe = { enabled = false }
        },
     }
    }
}

-- lspsaga
local saga = require 'lspsaga'

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
  code_action_prompt = {
      enable = false
  }
}
EOF

nnoremap <silent> <leader>cF :Lspsaga lsp_finder<CR>
nnoremap <silent> <leader>cP :Lspsaga preview_definition<CR>

lua << EOF

-- telescope
function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous
      },
      n = {
        ["q"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous
      },
    },
  }
}
EOF

nnoremap <silent> <leader>pf <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <silent> <leader>pb <cmd>lua require('telescope.builtin').file_browser()<CR>
nnoremap <silent> <leader>/ <cmd>lua require('telescope.builtin').live_grep()<CR>

nnoremap <silent> <leader>gg :Git<CR>
" }}}
