-- Basic
local vim = vim
local set = vim.opt
local setlocal = vim.opt_local
local map = vim.keymap.set

-- Settings
set.encoding = 'utf8'
set.mouse = 'a'
set.so = 999 -- Keep cursor centered vertically
set.number = true
set.hidden = true

-- Indentation
set.autoindent = true
set.smartindent = true

set.expandtab = true
set.smarttab = true

set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'javascript,typescript,typescriptreact,haskell,css,scss,html,purescript,svelte,lua',
  callback = function()
    setlocal.ts = 2
    setlocal.sts = 2
    setlocal.sw = 2
  end
})


set.splitbelow = true
set.splitright = true

set.list = true
set.listchars = { tab = '|▸', trail = '·' }

vim.cmd [[
    syntax enable
]]

set.signcolumn = 'yes'

-- Theming
set.termguicolors = true
vim.cmd [[
    colorscheme OceanicNext
]]

-- Behaviour
-- Remember cursor position between sessions
vim.cmd [[
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line ("'\"") <= line("$") |
                \   exe "normal! g'\"" |
                \ endif
]]

-- Save undos
set.undodir = os.getenv("HOME") .. '/.config/nvim/undodir'
set.undofile = true

-- Folding
set.foldmethod = 'syntax'
set.foldlevelstart = 20
set.foldenable = false


-- Key bindings
vim.g.mapleader = " "
map('n', '<Space>', '<nop>')

-- Common sense
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-h>', '<C-w>h')

-- Easier to reach
map('n', ',', ':')
map('v', ',', ':')
map('n', ':', '<nop>')
map('v', ':', '<nop>')

-- Clear highlights
map('n', '<ESC>', ':noh<CR>', { silent = true })

-- Highlight without jumping
map('n', '*', '*N')

-- Change word under cursor and repeat with dot operator (or n. to preview)
map('n', 'c*', '*Ncgn')

map('n', '<Left>', '<<')
map('n', '<Right>', '>>')
map('v', '<Left>', '<gv')
map('v', '<Right>', '>gv')


-- Prevent accidental command history buffer
map('n', 'q:', '<nop>')
map('n', 'Q', '<nop>')


-- Plugins
require('Comment').setup({
  toggler = {
    line = '<leader>cc',
    block = '<leader>cb',
  },
  opleader = {
    line = '<leader>cc',
    block = '<leader>cb',
  },
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

map('n', '-', ':NvimTreeFindFileToggle!<CR>', { silent = true })

map('n', '<leader>gg', ':Neogit<CR>', { silent = true })

map('n', '<C-Space>', '<CMD>lua require("FTerm").toggle()<CR>', { silent = true })
map('t', '<C-Space>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { silent = true })

-- gitsigns
require("gitsigns").setup()

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
  view = {
    mappings = {
      list = {
        { key = "-", action = "close" },
      },
    },
  },
})


-- lualine
require('lualine').setup({
  options = {
    icons_enabled = true,
  },
  sections = {
    lualine_a = {
      { 'filename', path = 1 }
    }
  }
})


-- nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<S-Tab>'] = cmp.mapping(function() luasnip.jump(1) end),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
vim.o.completeopt = 'menu,menuone,noselect'

local nvim_cmp_capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- luasnip
require("luasnip.loaders.from_vscode").lazy_load()


-- nvim-lspconfig
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<Up>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<Down>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>cR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>cA', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)

  if client.server_capabilities.documentFormattingProvider then
    vim.cmd [[augroup Format]]
    vim.cmd [[autocmd! * <buffer>]]
    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format { async = false }]]
    vim.cmd [[augroup END]]
  end
end

nvim_lsp.ccls.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  }
}

-- This workaround is necessary, as for some reasen typescript-language-server does not list typescript as a dependency (?!)
local handle = io.popen("/usr/bin/env which tsserver")
local tsserver = "tsserver-not-found"
if handle ~= nil then
  tsserver = handle:read("*a")
  tsserver = string.gsub(tsserver, "\n", "")
  handle:close()
  -- print("Found tsserver at '" .. tsserver .. "'")
end

nvim_lsp.tsserver.setup {
  cmd = { "typescript-language-server", "--stdio", "--tsserver-path", tsserver },
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.ccls.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.pylsp.setup {
  cmd = { "pylsp_wrapped" },
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
  },
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.hls.setup {
  cmd = { "hls_wrapped" },
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.dartls.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.purescriptls.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.svelte.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.tailwindcss.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = nvim_cmp_capabilities
}


-- telescope
function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.load_extension('project')

telescope.setup {
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

-- Telescope: Files and grep
map('n', '<leader>pf', '<cmd>lua require("telescope.builtin").find_files()<CR>')
map('n', '<leader>pF',
  '<cmd>lua require("telescope.builtin").find_files{ hidden = true, no_ignore = true, no_ignore_parent = true }<CR>')
map('n', '<leader>pp', '<cmd>lua require("telescope").extensions.project.project{}<CR>')
map('n', '<leader>/', '<cmd>lua require("telescope.builtin").live_grep()<CR>')

-- Telescope: LSP
map('n', '<leader>cD', '<cmd>lua require("telescope.builtin").diagnostics()<CR>')
map('n', '<leader>cr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>')
map('n', '<leader>cd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>')
map('n', '<leader>ct', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>')
map('n', '<leader>ci', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>')
map('n', '<leader>cs', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>')
map('n', '<leader>cS', '<cmd>lua require("telescope.builtin").lsp_workspace_symbols()<CR>')



-- tree-sitter
local ts_parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'org' },
  },
  ensure_installed = {},
  parser_install_dir = ts_parser_install_dir
}
vim.opt.runtimepath:append(ts_parser_install_dir)

-- orgmode
require('orgmode').setup {}
require('orgmode').setup_ts_grammar()
require("org-bullets").setup {
  symbols = { "◉", "○", "✸", "✿" }
}
