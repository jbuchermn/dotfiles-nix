-- NOTE: These 2 need to be set up before any plugins are loaded.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Set highlight on search
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Highlight without jumping
vim.keymap.set("n", "*", "*N")

-- Split to the right and below
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Keep cursor centered vertically
vim.opt.scrolloff = 999

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Indent
-- vim.o.smarttab = true
vim.opt.cpoptions:append("I")
vim.o.expandtab = true
-- vim.o.smartindent = true
-- vim.o.autoindent = true
-- vim.o.tabstop = 4
-- vim.o.softtabstop = 4
-- vim.o.shiftwidth = 4

-- stops line wrapping from being confusing
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"
vim.wo.relativenumber = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,preview,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Disable auto comment on enter ]]
-- See :help formatoptions
vim.api.nvim_create_autocmd("FileType", {
  desc = "remove formatoptions",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Remember cursor position between sessions
vim.cmd([[
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line ("'\"") <= line("$") |
                \   exe "normal! g'\"" |
                \ endif
]])

vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0
-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- Window navigation
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
-- Terminal window navigation
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Window down" })
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Window up" })
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Window right" })
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Window left" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves Line Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves Line Up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous Search Result" })

vim.keymap.set("n", "<leader><leader>[", "<cmd>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader><leader>]", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader><leader>l", "<cmd>b#<CR>", { desc = "Last buffer" })
vim.keymap.set("n", "<leader><leader>d", "<cmd>bdelete<CR>", { desc = "delete buffer" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Easier to reach command mode
vim.keymap.set("n", ",", ":")
vim.keymap.set("v", ",", ":")
vim.keymap.set("n", ":", "<nop>")
vim.keymap.set("v", ":", "<nop>")

-- Arrow key indentation
vim.keymap.set("n", "<Left>", "<<")
vim.keymap.set("n", "<Right>", ">>")
vim.keymap.set("v", "<Left>", "<gv")
vim.keymap.set("v", "<Right>", ">gv")

-- Prevent accidental command history buffer
vim.keymap.set("n", "q:", "<nop>")
vim.keymap.set("n", "Q", "<nop>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- You should instead use these keybindings so that they are still easy to use, but dont conflict
vim.keymap.set({ "v", "x", "n" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set(
  { "n", "v", "x" },
  "<leader>Y",
  '"+yy',
  { noremap = true, silent = true, desc = "Yank line to clipboard" }
)
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.keymap.set(
  "i",
  "<C-p>",
  "<C-r><C-p>+",
  { noremap = true, silent = true, desc = "Paste from clipboard from within insert mode" }
)
vim.keymap.set(
  "x",
  "<leader>P",
  '"_dP',
  { noremap = true, silent = true, desc = "Paste over selection without erasing unnamed register" }
)

vim.cmd.colorscheme("onedark")
require("snacks").setup({
  explorer = {},
  picker = {},
  bigfile = {},
  image = {},
  lazygit = {},
  terminal = {},
  rename = {},
  notifier = {},
  indent = {},
  gitbrowse = {},
  scope = {},
})
vim.keymap.set("n", "-", function()
  Snacks.explorer.open()
end, { desc = "Snacks Explorer" })
vim.keymap.set("n", "<leader>tt", function()
  Snacks.terminal.open()
end, { desc = "Snacks Terminal" })
vim.keymap.set({ "n", "t" }, "<c-space>", function()
  Snacks.terminal.toggle("echo 0 > /dev/null; zsh", { -- use command as id
    win = {
      style = "float",
    },
  })
end, { desc = "Toggle Full-Screen Terminal" })
vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit.open()
end, { desc = "Snacks LazyGit" })
vim.keymap.set("n", "<leader>fs", function()
  Snacks.picker.buffers()
end, { desc = "Search Buffers" })
-- find
vim.keymap.set("n", "<leader>ff", function()
  Snacks.picker.smart()
end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>fF", function()
  Snacks.picker.git_files()
end, { desc = "Find Git Files" })
-- Grep
vim.keymap.set("n", "<leader>sb", function()
  Snacks.picker.lines()
end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sB", function()
  Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
vim.keymap.set("n", "<leader>/", function()
  Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function()
  Snacks.picker.grep_word()
end, { desc = "Visual selection or ord" })
-- search
vim.keymap.set("n", "<leader>sb", function()
  Snacks.picker.lines()
end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sd", function()
  Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sD", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sh", function()
  Snacks.picker.help()
end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sj", function()
  Snacks.picker.jumps()
end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", function()
  Snacks.picker.loclist()
end, { desc = "Location List" })
vim.keymap.set("n", "<leader>sm", function()
  Snacks.picker.marks()
end, { desc = "Marks" })
vim.keymap.set("n", "<leader>sM", function()
  Snacks.picker.man()
end, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sq", function()
  Snacks.picker.qflist()
end, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sR", function()
  Snacks.picker.resume()
end, { desc = "Resume" })
vim.keymap.set("n", "<leader>su", function()
  Snacks.picker.undo()
end, { desc = "Undo History" })
require("lze").load({
  {
    "blink.cmp",
    enabled = nixCats("general") or false,
    event = "DeferredUIEnter",
    on_require = "blink",
    after = function(plugin)
      require("blink.cmp").setup({
        keymap = {
          preset = "none",
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<Tab>"] = { "accept", "fallback" },
          ["<C-e>"] = { "hide", "fallback" },
        },
        appearance = {
          nerd_font_variant = "mono",
        },
        signature = { enabled = true },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
      })
    end,
  },
  {
    "nvim-treesitter",
    enabled = nixCats("general") or false,
    -- cmd = { "" },
    event = "DeferredUIEnter",
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("nvim-treesitter-textobjects")
    end,
    after = function(plugin)
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = false },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Tab>",
            node_incremental = "<Tab>",
            node_decremental = "<S-Tab>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
  {
    "mini.nvim",
    enabled = nixCats("general") or false,
    event = "DeferredUIEnter",
    after = function(plugin)
      require("mini.pairs").setup()
      require("mini.icons").setup()
      require("mini.ai").setup()
      require("mini.comment").setup({
        mappings = {
          comment_line = "<leader>cc",
          comment_visual = "<leader>cc",
        },
      })
    end,
  },
  {
    "vim-startuptime",
    enabled = nixCats("general") or false,
    cmd = { "StartupTime" },
    before = function(_)
      vim.g.startuptime_event_width = 0
      vim.g.startuptime_tries = 10
      vim.g.startuptime_exe_path = nixCats.packageBinPath
    end,
  },
  {
    "lualine.nvim",
    enabled = nixCats("general") or false,
    -- cmd = { "" },
    event = "DeferredUIEnter",
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("lualine-lsp-progress")
    end,
    after = function(plugin)
      require("lualine").setup({
        options = {
          icons_enabled = false,
          theme = "onedark",
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_c = {
            {
              "filename",
              path = 1,
              status = true,
            },
          },
        },
        inactive_sections = {
          lualine_b = {
            {
              "filename",
              path = 3,
              status = true,
            },
          },
          lualine_x = { "filetype" },
        },
        tabline = {
          lualine_a = { "buffers" },
          lualine_b = { "lsp_progress" },
          lualine_z = { "tabs" },
        },
      })
    end,
  },
  {
    "gitsigns.nvim",
    enabled = nixCats("general") or false,
    event = "DeferredUIEnter",
    -- cmd = { "" },
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    after = function(plugin)
      require("gitsigns").setup({
        -- See `:help gitsigns.txt`
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map({ "n", "v" }, "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Jump to next hunk" })

          map({ "n", "v" }, "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true, desc = "Jump to previous hunk" })

          -- Actions
          -- visual mode
          map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "stage git hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "reset git hunk" })
          -- normal mode
          map("n", "<leader>gs", gs.stage_hunk, { desc = "git stage hunk" })
          map("n", "<leader>gr", gs.reset_hunk, { desc = "git reset hunk" })
          map("n", "<leader>gS", gs.stage_buffer, { desc = "git Stage buffer" })
          map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
          map("n", "<leader>gR", gs.reset_buffer, { desc = "git Reset buffer" })
          map("n", "<leader>gp", gs.preview_hunk, { desc = "preview git hunk" })
          map("n", "<leader>gb", function()
            gs.blame_line({ full = false })
          end, { desc = "git blame line" })
          map("n", "<leader>gd", gs.diffthis, { desc = "git diff against index" })
          map("n", "<leader>gD", function()
            gs.diffthis("~")
          end, { desc = "git diff against last commit" })

          -- Toggles
          map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
          map("n", "<leader>gtd", gs.toggle_deleted, { desc = "toggle git show deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
        end,
      })
      vim.cmd([[hi GitSignsAdd guifg=#04de21]])
      vim.cmd([[hi GitSignsChange guifg=#83fce6]])
      vim.cmd([[hi GitSignsDelete guifg=#fa2525]])
    end,
  },
  {
    "which-key.nvim",
    enabled = nixCats("general") or false,
    event = "DeferredUIEnter",
    after = function(plugin)
      require("which-key").setup({})
      require("which-key").add({
        { "<leader><leader>", group = "buffer commands" },
        { "<leader><leader>_", hidden = true },
        { "<leader>c", group = "[c]ode" },
        { "<leader>c_", hidden = true },
        { "<leader>d", group = "[d]ocument" },
        { "<leader>d_", hidden = true },
        { "<leader>g", group = "[g]it" },
        { "<leader>g_", hidden = true },
        { "<leader>r", group = "[r]ename" },
        { "<leader>r_", hidden = true },
        { "<leader>f", group = "[f]ind" },
        { "<leader>f_", hidden = true },
        { "<leader>s", group = "[s]earch" },
        { "<leader>s_", hidden = true },
        { "<leader>t", group = "[t]oggles" },
        { "<leader>t_", hidden = true },
        { "<leader>w", group = "[w]orkspace" },
        { "<leader>w_", hidden = true },
      })
    end,
  },
  {
    "nvim-lint",
    enabled = nixCats("general") or false,
    event = "FileType",
    after = function(plugin)
      require("lint").linters_by_ft = {
        -- NOTE: download some linters in lspsAndRuntimeDeps
        -- and configure them here
        -- markdown = {'vale',},
        -- javascript = { 'eslint' },
        typescript = nixCats("typescript") and { "eslint" } or nil,
        -- go = nixCats('go') and { 'golangcilint' } or nil,
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "conform.nvim",
    enabled = nixCats("general") or false,
    keys = {
      { "<leader>cf", desc = "[F]ormat [F]ile" },
    },
    -- colorscheme = "",
    after = function(plugin)
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- NOTE: download some formatters in lspsAndRuntimeDeps
          -- and configure them here
          lua = nixCats("lua") and { "stylua" } or nil,
          nix = nixCats("nix") and { "alejandra" } or nil,
          -- templ = { "templ" },
          -- Conform will run multiple formatters sequentially
          -- python = { "isort", "black" },
          -- Use a sub-list to run only the first available formatter
          -- javascript = { { "prettierd", "prettier" } },
        },
      })

      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "[F]ormat [F]ile" })

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          })
        end,
      })
    end,
  },
  {
    "nvim-dap",
    enabled = nixCats("general") or false,
    -- cmd = { "" },
    -- event = "",
    -- ft = "",
    keys = {
      { "<F5>", desc = "Debug: Start/Continue" },
      { "<F1>", desc = "Debug: Step Into" },
      { "<F2>", desc = "Debug: Step Over" },
      { "<F3>", desc = "Debug: Step Out" },
      { "<leader>b", desc = "Debug: Toggle Breakpoint" },
      { "<leader>B", desc = "Debug: Set Breakpoint" },
      { "<F7>", desc = "Debug: See last session result." },
    },
    -- colorscheme = "",
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("nvim-dap-ui")
      vim.cmd.packadd("nvim-dap-virtual-text")
    end,
    after = function(plugin)
      local dap = require("dap")
      local dapui = require("dapui")

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Set Breakpoint" })

      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup({
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      })

      require("nvim-dap-virtual-text").setup({
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
        --- A callback that determines how a variable is displayed or whether it should be omitted
        --- variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
        --- buf number
        --- stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
        --- node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
        --- options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
        --- string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
        -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

        -- experimental features:
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
        -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
      })

      -- NOTE: Install lang specific config
      -- either in here, or in a separate plugin spec as demonstrated for go below.
    end,
  },
  {
    "render-markdown.nvim",
    enabled = nixCats("markdown") or false,
    after = function(_)
      require("render-markdown").setup({
        completions = { lsp = { enabled = true } },
        code = {
          border = "thick",
        },
        checkbox = { checked = { scope_highlight = '@markup.strikethrough' } },
      })
    end,
  },
  {
    "opdavies-toggle-checkbox.nvim",
    enabled = nixCats("markdown") or false,
    after = function(_)
      vim.keymap.set("n", "<CR>", ":lua require('toggle-checkbox').toggle()<CR>", { desc = "Toggle checkbox" })
    end,
  },
  {
    -- lazydev makes your lsp way better in your config without needing extra lsp configuration.
    "lazydev.nvim",
    enabled = nixCats("lua") or false,
    cmd = { "LazyDev" },
    ft = "lua",
    after = function(_)
      require("lazydev").setup({
        library = {
          { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. "/lua" },
        },
      })
    end,
  },
})

local function lsp_on_attach(_, bufnr)
  -- we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.

  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")

  if nixCats("general") then
    nmap("gr", function()
      Snacks.picker.lsp_references()
    end, "[G]oto [R]eferences")
    nmap("gI", function()
      Snacks.picker.lsp_implementations()
    end, "[G]oto [I]mplementation")
    nmap("<leader>ds", function()
      Snacks.picker.lsp_symbols()
    end, "[D]ocument [S]ymbols")
    nmap("<leader>ws", function()
      Snacks.picker.lsp_workspace_symbols()
    end, "[W]orkspace [S]ymbols")
    -- Old keybindings
    nmap("<leader>cr", function()
      Snacks.picker.lsp_references()
    end, "[G]oto [R]eferences")
    nmap("<leader>ci", function()
      Snacks.picker.lsp_implementations()
    end, "[G]oto [I]mplementation")
    nmap("<leader>cs", function()
      Snacks.picker.lsp_symbols()
    end, "[D]ocument [S]ymbols")
    nmap("<leader>cS", function()
      Snacks.picker.lsp_workspace_symbols()
    end, "[W]orkspace [S]ymbols")
    nmap("<leader>cD", function()
      Snacks.picker.diagnostics()
    end, "Diagnostics")
    nmap("<leader>cd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("<leader>ct", vim.lsp.buf.type_definition, "Type [D]efinition")
  end

  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format()
  end, { desc = "Format current buffer with LSP" })
end

-- NOTE: Register a handler from lzextras. This one makes it so that
-- you can set up lsps within lze specs,
-- and trigger vim.lsp.enable and the rtp config collection only on the correct filetypes
-- it adds the lsp field used below
-- (and must be registered before any load calls that use it!)
require("lze").register_handlers(require("lzextras").lsp)
-- also replace the fallback filetype list retrieval function with a slightly faster one
require("lze").h.lsp.set_ft_fallback(function(name)
  return dofile(nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" }) .. "/lsp/" .. name .. ".lua").filetypes
    or {}
end)
require("lze").load({
  {
    "nvim-lspconfig",
    enabled = nixCats("general") or false,
    -- the on require handler will be needed here if you want to use the
    -- fallback method of getting filetypes if you don't provide any
    on_require = { "lspconfig" },
    -- define a function to run over all type(plugin.lsp) == table
    -- when their filetype trigger loads them
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(_)
      vim.lsp.config("*", {
        on_attach = lsp_on_attach,
      })
    end,
  },
  {
    -- name of the lsp
    "lua_ls",
    enabled = nixCats("lua") or false,
    -- provide a table containing filetypes,
    -- and then whatever your functions defined in the function type specs expect.
    -- in our case, it just expects the normal lspconfig setup options.
    lsp = {
      -- if you provide the filetypes it doesn't ask lspconfig for the filetypes
      filetypes = { "lua" },
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          formatters = {
            ignoreComments = true,
          },
          signatureHelp = { enabled = true },
          diagnostics = {
            globals = { "nixCats", "vim" },
            disable = { "missing-fields" },
          },
          telemetry = { enabled = false },
        },
      },
    },
    -- also these are regular specs and you can use before and after and all the other normal fields
  },
  {
    "nixd",
    enabled = nixCats("nix") or false,
    lsp = {
      filetypes = { "nix" },
      settings = {
        nixd = {
          -- nixd requires some configuration.
          -- luckily, the nixCats plugin is here to pass whatever we need!
          -- we passed this in via the `extra` table in our packageDefinitions
          -- for additional configuration options, refer to:
          -- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
          nixpkgs = {
            -- in the extras set of your package definition:
            -- nixdExtras.nixpkgs = ''import ${pkgs.path} {}''
            expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
          },
          options = {
            nixos = {
              -- nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").nixosConfigurations.configname.options''
              expr = nixCats.extra("nixdExtras.nixos_options"),
            },
            ["home-manager"] = {
              -- nixdExtras.home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").homeConfigurations.configname.options''
              expr = nixCats.extra("nixdExtras.home_manager_options"),
            },
          },
          formatting = {
            command = { "alejandra" },
          },
          diagnostic = {
            suppress = {
              "sema-escaping-with",
            },
          },
        },
      },
    },
  },
  {
    "ts_ls",
    enabled = nixCats("typescript") or false,
    before = function(plugin)
      plugin.lsp.cmd = vim.fn.executable("typescript-language-server") == 1
          and { "typescript-language-server", "--stdio" }
        or { nixCats.extra("typescript.typescript-language-server"), "--stdio" }
    end,
    lsp = {
      filetypes = { "typescript" },
      settings = {},
    },
  },
  {
    "svelte",
    enabled = nixCats("typescript") or false,
    before = function(plugin)
      plugin.lsp.cmd = vim.fn.executable("svelteserver") == 1 and { "svelteserver", "--stdio" }
        or { nixCats.extra("typescript.svelteserver"), "--stdio" }
    end,
    lsp = {
      filetypes = { "svelte" },
      settings = {},
    },
  },
  {
    "tailwindcss",
    enabled = nixCats("typescript") or false,
    before = function(plugin)
      plugin.lsp.cmd = vim.fn.executable("tailwindcss-language-server") == 1
          and { "tailwindcss-language-server", "--stdio" }
        or { nixCats.extra("typescript.tailwindcss-language-server"), "--stdio" }
    end,
    lsp = {
      filetypes = { "svelte", "html", "css" },
      settings = {},
    },
  },
  {
    "pylsp",
    enabled = nixCats("python") or false,
    before = function(plugin)
      plugin.lsp.cmd = vim.fn.executable("pylsp") == 1 and { "pylsp" } or { nixCats.extra("python.pylsp") }
    end,
    lsp = {
      filetypes = { "python" },
      settings = {},
    },
  },
})
