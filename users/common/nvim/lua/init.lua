-------------------------------------
-- Basic
-------------------------------------
local vim = vim
local set = vim.opt
local setlocal = vim.opt_local
local map = vim.keymap.set

vim.loader.enable()

-- Settings
set.termguicolors = true
set.encoding = 'utf8'
set.mouse = 'a'
set.so = 999 -- Keep cursor centered vertically
set.number = true
set.hidden = true

set.shell = '/bin/bash'

-- Indentation
set.autoindent = true
set.smartindent = true

set.expandtab = true
set.smarttab = true

set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4

set.splitbelow = true
set.splitright = true

set.list = true
set.listchars = { tab = '|▸', trail = '·' }

set.signcolumn = 'yes'

-- Save undos
set.undodir = vim.env.HOME .. '/.config/nvim/undodir'
set.undofile = true

-- Folding
set.foldmethod = 'syntax'
set.foldlevelstart = 20
set.foldenable = false

-------------------------------------
-- Key bindings
-------------------------------------
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

-- Fold with Tab
map('n', '<Tab>', 'za', { noremap = true })


-------------------------------------
-- Autocommands
-------------------------------------
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'javascript,typescript,typescriptreact,haskell,css,scss,html,purescript,svelte,lua,c,h',
  callback = function()
    setlocal.ts = 2
    setlocal.sts = 2
    setlocal.sw = 2
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'sh',
  callback = function()
    set.expandtab = false
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  callback = function()
    set.conceallevel = 2
  end
})

-- Remember cursor position between sessions
vim.cmd [[
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line ("'\"") <= line("$") |
                \   exe "normal! g'\"" |
                \ endif
]]

-------------------------------------
-- Plugins - TODO: Move to seperate files (https://www.reddit.com/r/NixOS/comments/xa30jq/homemanager_nvim_lua_config_for_plugins/)
-------------------------------------
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


map('n', '<C-Space>', '<CMD>lua require("FTerm").toggle()<CR>', { silent = true })
map('t', '<C-Space>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { silent = true })

require('toggleterm').setup {}
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

-- neogit
require("neogit").setup {
}
map('n', '<leader>gg', ':Neogit<CR>', { silent = true })

-- gitsigns
require("gitsigns").setup()

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- BEGIN_DEFAULT_ON_ATTACH
    vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
    vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts('Info'))
    vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
    vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
    vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
    vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
    vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
    vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
    vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
    vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
    vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
    vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
    vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
    vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
    vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
    vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
    vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
    vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
    vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
    vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
    vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
    vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
    vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
    vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
    vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
    vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
    vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
    vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
    vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))
    vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
    vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
    vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
    vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
    vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
    vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
    vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
    vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
    vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
    vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
    vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
    vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
    vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
    vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
    vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
    vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
    -- END_DEFAULT_ON_ATTACH

    vim.keymap.set('n', '-', api.tree.close, opts('Close'))
  end
})

-- oil.nvim
require('oil').setup()
vim.keymap.set('n', '_', require('oil').open, { desc = "Open oil in parent directory" });


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

local on_attach_enable_format = function(client, bufnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd [[augroup Format]]
    vim.cmd [[autocmd! * <buffer>]]
    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format { async = false }]]
    vim.cmd [[augroup END]]
  end
end

local on_attach_std_keybindings = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<Up>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<Down>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>cR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>cA', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>cf', '<cmd>lua vim.lsp.buf.format { async = true }<CR>', opts)
end

local on_attach = function(client, bufnr)
  on_attach_std_keybindings(client, bufnr)
  on_attach_enable_format(client, bufnr)

  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })
end


local flags = {
  debounce_text_changes = 150
}

nvim_lsp.ccls.setup {
  on_attach = on_attach,
  flags = flags
}

nvim_lsp.ts_ls.setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.ccls.setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.pylsp.setup {
  cmd = { "pylsp_wrapped" },
  flags = flags,
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

function on_attach_haskell(client, bufnr, ht)
  local opts = { noremap = true, silent = true, buffer = bufnr, }

  on_attach_enable_format(client, bufnr)
  on_attach_std_keybindings(client, bufnr)

  vim.keymap.set('n', '<leader>ch', ht.hoogle.hoogle_signature, opts)

  vim.keymap.set('n', '<leader>ea', ht.lsp.buf_eval_all, opts)

  vim.keymap.set('n', '<leader>rr', ht.repl.toggle, opts)
  vim.keymap.set('n', '<leader>rf', function()
    ht.repl.toggle(vim.api.nvim_buf_get_name(0))
  end, opts)
  vim.keymap.set('n', '<leader>rq', ht.repl.quit, opts)
end

vim.g.haskell_tools = {
  hls = {
    on_attach = on_attach_haskell
  },
  tools = {
    repl = {
      handler = 'toggleterm',
    },
  }
}

nvim_lsp.dartls.setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.purescriptls.setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.svelte.setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.tailwindcss.setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.lua_ls.setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = nvim_cmp_capabilities
}

nvim_lsp.nil_ls.setup {
  on_attach = on_attach,
  flags = flags,
  capabilities = nvim_cmp_capabilities,
  settings = {
    ['nil'] = {
      formatting = {
        command = { 'nixpkgs-fmt' }
      }
    }
  }
}


-- telescope
function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.load_extension('project')
telescope.load_extension('hoogle')

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
  },
}

-- telescope: files and grep
map('n', '<leader>pp', '<cmd>lua require("telescope").extensions.project.project{}<CR>')
map('n', '<leader>pf', '<cmd>lua require("telescope.builtin").find_files()<CR>')
map('n', '<leader>pF',
  '<cmd>lua require("telescope.builtin").find_files{ hidden = true, no_ignore = true, no_ignore_parent = true }<CR>')
map('n', '<leader>/', '<cmd>lua require("telescope.builtin").live_grep()<CR>')

-- telescope: LSP
map('n', '<leader>cD', '<cmd>lua require("telescope.builtin").diagnostics()<CR>')
map('n', '<leader>cr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>')
map('n', '<leader>cd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>')
map('n', '<leader>ct', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>')
map('n', '<leader>ci', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>')
map('n', '<leader>cs', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>')
map('n', '<leader>cS', '<cmd>lua require("telescope.builtin").lsp_workspace_symbols()<CR>')

-- telescope: Haskell
map('n', '<leader>hh', '<cmd>lua require("telescope").extensions.hoogle.hoogle{}<CR>')

-- tree-sitter
local ts_parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = {},
  },
  ensure_installed = {},
  parser_install_dir = ts_parser_install_dir
}
vim.opt.runtimepath:append(ts_parser_install_dir)

-- orgmode
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, '@org.headline.level1', { bold = true, underline = true })
    vim.api.nvim_set_hl(0, '@org.headline.level2', { bold = true, underline = true })
    vim.api.nvim_set_hl(0, '@org.headline.level3', { bold = true, underline = true })

    vim.api.nvim_set_hl(0, '@org.headline.level4', {})
    vim.api.nvim_set_hl(0, '@org.headline.level5', {})
    vim.api.nvim_set_hl(0, '@org.headline.level6', {})
    vim.api.nvim_set_hl(0, '@org.headline.level7', {})
  end
})

require('orgmode').setup {
  -- org_agenda_files = { vim.env.MHP .. '/Agenda/**/*', '~/org/**/*' },
  -- org_default_notes_file = vim.env.MHP .. '~/Agenda/notes.org',
  org_startup_folded = 'showeverything',
  org_todo_keywords = { 'OPEN(o)', 'BACK(3)', 'CURR(2)', 'PRIO(1)', 'PEND(p)', '|', 'DONE(d)' },
  org_todo_keyword_faces = {
    OPEN = ':foreground #FFFFFF :weight bold',
    BACK = ':foreground #00FFFF :weight bold',
    CURR = ':foreground #FF0000 :weight bold',
    PRIO = ':foreground #EE82EE :weight bold',
    PEND = ':foreground #00FFFF :weight bold',
    DONE = ':foreground #568203 :weight regular :slant italic',
  },
  org_log_done = false,

  mappings = {
    org = {
      org_cycle = false,
      org_todo = '<leader>t'
    }
  },
}

vim.cmd [[highlight Headline1 guibg=#512bd4]]
vim.cmd [[highlight Headline2 guibg=#00afff]]
vim.cmd [[highlight Headline3 guibg=#6699cc]]

require("headlines").setup {
  org = {
    fat_headlines = false,
    bullets = { "◉", "○", "✸", "-" },
    headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4" },
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  callback = function()
    local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    local update_script = 'org_update.py'

    if not vim.uv.fs_stat(dir .. "/" .. update_script) then
      update_script = nil
    end

    if update_script ~= nil then
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*',
        callback = function()
          vim.fn.jobstart(dir .. "/" .. update_script)
        end
      })
    end
  end
})

-- fwatch.nvim: autoread org_summary.org
local fwatch = require('fwatch')

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  callback = function()
    local name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
    if name == 'org_summary.org' then
      vim.cmd [[ set autoread ]]

      fwatch.watch(vim.api.nvim_buf_get_name(0), {
        on_event = function()
          vim.schedule(function()
            vim.cmd [[ checktime ]]
          end)
        end
      })
    end
  end
})

-- avante.nvim
require("avante_lib").load()
require('avante').setup({
  -- Your other config here!
  provider = "gemini",
  providers = {
    claude = {
      endpoint = "https://api.anthropic.com",
      model = "claude-sonnet-4-20250514",
      timeout = 30000, -- Timeout in milliseconds
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 20480,
      },
    },
    gemini = {
      endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
      model = "gemini-2.0-flash",
      timeout = 30000, -- Timeout in milliseconds
      context_window = 1048576,
      use_ReAct_prompt = true,
      extra_request_body = {
        generationConfig = {
          temperature = 0.75,
        },
      },
    },
  }
})


-------------------------------------
-- Theming
-------------------------------------
vim.cmd [[
    syntax enable
    colorscheme OceanicNext
]]


-------------------------------------
-- Playground
-------------------------------------
-- neorg
-- require("neorg").setup {
--   load = {
--     ["core.defaults"] = {},
--     ["core.dirman"] = {
--       config = {
--         workspaces = {
--           main = "~/agenda",
--           mhp = vim.env.MHP .. "/Agenda"
--         },
--         default_workspace = "main"
--       },
--     },
--     ["core.concealer"] = {
--       config = {
--         icons = {
--           todo = {
--             urgent = {
--               icon = "",
--             },
--             undone = {
--               icon = " ",
--             },
--             cancelled = {
--               icon = "x",
--             },
--             done = {
--               icon = "",
--             },
--             pending = {
--               icon = "-",
--             },
--             on_hold = {
--               icon = "h",
--             },
--             recurring = {
--               icon = "r",
--             },
--           },
--         },
--       },
--     }
--   }
-- }


-- require("org-bullets").setup {
--   concealcursor = false,
--   symbols = {
--     list = "•",
--     headlines = { "◉", "○", "✸", "✿" },
--     checkboxes = {
--       done = { "✓", "OrgDone" },
--       todo = { "˟", "OrgTODO" },
--     },
--   }
-- }
