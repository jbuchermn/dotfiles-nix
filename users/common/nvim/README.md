# Neovim Configuration Documentation

This document describes the current Neovim configuration in `users/common/nvim/` and compares it to the old configuration in `users/common/nvim-old/`.

## New Configuration Overview

The new configuration uses the `lze` plugin manager for lazy loading and is structured around categories of plugins (general, lua, nix, go). It focuses on modern Neovim features with a clean, minimal setup.

### Categories and Plugins

#### Core Plugins (Startup)
- **lze**: Plugin manager for lazy loading
- **lzextras**: Extra utilities for lze
- **snacks-nvim**: Collection of small utilities (explorer, picker, terminal, etc.)
- **onedark-nvim**: Color scheme
- **vim-sleuth**: Automatic indentation detection

#### General Plugins
- **blink.cmp**: Fast completion engine
- **nvim-treesitter**: Syntax highlighting and parsing
- **mini.nvim**: Collection of small plugins (pairs, icons, ai, comment)
- **vim-startuptime**: Startup time profiler
- **lualine.nvim**: Status line with LSP progress
- **gitsigns.nvim**: Git integration (signs, hunks)
- **which-key.nvim**: Keybinding hints
- **nvim-lint**: Linting framework
- **conform.nvim**: Formatting framework
- **nvim-dap**: Debug adapter protocol
- **nvim-dap-ui**: DAP UI
- **nvim-dap-virtual-text**: Virtual text for debugging
- **nvim-lspconfig**: LSP configuration

#### Language-Specific Plugins
- **lua**: lazydev.nvim (better Lua LSP support)
- **go**: nvim-dap-go (Go debugging)
- **nix**: nixd (Nix LSP)
- **general**: lua_ls, gopls, nixd LSP servers

### Keybindings

#### Basic Navigation
- `<Space>`: Leader key
- `<Esc>`: Clear search highlights
- `<C-j/k/l/h>`: Window navigation (normal and terminal mode)
- `n`, `N`: Next/previous search result with centering
- `J`, `K` (visual): Move lines down/up
- `k`, `j`: Navigate wrapped lines
- `,`: Enter command mode (easier than `:`)
- `<Left>`, `<Right>`: Indent left/right (normal mode)
- `<Left>`, `<Right>` (visual): Indent left/right and reselect

#### Buffer Management
- `<leader><leader>[`, `<leader><leader>]`: Previous/next buffer
- `<leader><leader>l`: Last buffer
- `<leader><leader>d`: Delete buffer

#### Clipboard
- `<leader>y`: Yank to system clipboard
- `<leader>Y`: Yank line to system clipboard
- `<leader>p`: Paste from system clipboard
- `<C-p>` (insert): Paste from system clipboard

#### LSP
- `gd`: Go to definition
- `gr`: Go to references (via Snacks picker)
- `gI`: Go to implementation (via Snacks picker)
- `<leader>ds`: Document symbols (via Snacks picker)
- `<leader>ws`: Workspace symbols (via Snacks picker)
- `<leader>D`: Type definition
- `K`: Hover documentation
- `<C-K>`: Signature help
- `<leader>rn`: Rename
- `<leader>ca`: Code action
- `<leader>cf`: Format file
- `gD`: Declaration
- `<leader>wa`: Add workspace folder
- `<leader>wr`: Remove workspace folder
- `<leader>wl`: List workspace folders
- `<leader>cr`: Go to references (old key)
- `<leader>ci`: Go to implementation (old key)
- `<leader>cs`: Document symbols (old key)
- `<leader>cS`: Workspace symbols (old key)
- `<leader>cD`: Diagnostics (old key)
- `<leader>cd`: Go to definition (old key)
- `<leader>ct`: Type definition (old key)

#### Diagnostics
- `<leader>e`: Open floating diagnostic
- `<leader>q`: Open diagnostics list

#### Git (gitsigns)
- `]c`, `[c`: Next/previous hunk
- `<leader>gs`: Stage hunk
- `<leader>gr`: Reset hunk
- `<leader>gS`: Stage buffer
- `<leader>gu`: Undo stage hunk
- `<leader>gR`: Reset buffer
- `<leader>gp`: Preview hunk
- `<leader>gb`: Blame line
- `<leader>gd`: Diff against index
- `<leader>gD`: Diff against last commit
- `<leader>gtb`: Toggle blame line
- `<leader>gtd`: Toggle deleted
- `ih`: Select hunk (text object)

#### Treesitter
- `<Tab>`: Init selection / Node incremental
- `<S-Tab>`: Node decremental
- `aa`: Parameter outer
- `ia`: Parameter inner
- `af`: Function outer
- `if`: Function inner
- `ac`: Class outer
- `ic`: Class inner
- `]m`, `[[`: Next/previous function/class
- `]M`, `][`: Next/previous function/class end
- `[m`, `[[`: Previous function/class
- `[M`, `[]`: Previous function/class end
- `<leader>a`: Swap next parameter
- `<leader>A`: Swap previous parameter

#### Comments (mini.comment)
- `<leader>cc`: Comment/uncomment current line
- `<leader>cc` (visual): Comment/uncomment selection
- `gc{motion}`: Comment motion (e.g., `gcip` for paragraph)

#### Snacks
- `-`: Open explorer
- `<c-space>`: Toggle floating terminal
- `<leader>tt`: Open terminal
- `<leader>gg`: Open LazyGit
- `<leader>fs`: Search buffers
- `<leader>ff`: Smart find files
- `<leader>fF`: Find git files
- `<leader>sb`: Buffer lines
- `<leader>sB`: Grep open buffers
- `<leader>/`: Grep
- `<leader>sw`: Grep word (visual or under cursor)
- `<leader>sd`: Diagnostics
- `<leader>sD`: Buffer diagnostics
- `<leader>sh`: Help pages
- `<leader>sj`: Jumps
- `<leader>sk`: Keymaps
- `<leader>sl`: Location list
- `<leader>sm`: Marks
- `<leader>sM`: Man pages
- `<leader>sq`: Quickfix list
- `<leader>sR`: Resume
- `<leader>su`: Undo history

#### Debugging (DAP)
- `<F5>`: Start/Continue
- `<F1>`: Step Into
- `<F2>`: Step Over
- `<F3>`: Step Out
- `<leader>b`: Toggle breakpoint
- `<leader>B`: Set breakpoint with condition
- `<F7>`: Toggle DAP UI

#### Which-Key Groups
- `<leader><leader>`: Buffer commands
- `<leader>c`: Code
- `<leader>d`: Document
- `<leader>g`: Git
- `<leader>r`: Rename
- `<leader>f`: Find
- `<leader>s`: Search
- `<leader>t`: Toggles
- `<leader>w`: Workspace

#### Formatting/Linting
- `<leader>cf`: Format file

## Old Configuration Overview

The old configuration used a more traditional setup with plugins loaded directly in `init.lua`, including org-mode support and telescope for fuzzy finding.

### Plugins
- **Comment**: Commenting plugin
- **nvim-tree**: File explorer
- **FTerm**: Floating terminal
- **toggleterm**: Terminal management
- **neogit**: Git interface
- **gitsigns**: Git signs
- **oil.nvim**: File editing
- **lualine**: Status line
- **nvim-cmp**: Completion
- **luasnip**: Snippets
- **nvim-lspconfig**: LSP configuration
- **telescope**: Fuzzy finder
- **tree-sitter**: Syntax highlighting
- **orgmode**: Org-mode support
- **headlines**: Headline highlighting
- **fwatch**: File watching

### Keybindings

#### Basic
- `<Space>`: Leader
- `<C-j/k/l/h>`: Window navigation
- `,`: Command mode
- `<Esc>`: Clear highlights
- `*`: Highlight without jump
- `c*`: Change word and repeat
- `<Left>/<Right>`: Indent (normal/visual)
- `q:`: Disabled
- `Q`: Disabled
- `<Tab>`: Toggle fold

#### LSP
- `K`: Hover
- `<Up>/<Down>`: Previous/next diagnostic
- `<leader>cR`: Rename
- `<leader>cA`: Code action
- `<leader>cf`: Format

#### Haskell-specific
- `<leader>ch`: Hoogle signature
- `<leader>ea`: Eval all
- `<leader>rr`: Toggle REPL
- `<leader>rf`: REPL for file
- `<leader>rq`: Quit REPL

#### Telescope
- `<leader>pp`: Projects
- `<leader>pf`: Find files
- `<leader>pF`: Find files (hidden)
- `<leader>/`: Live grep
- `<leader>cD`: Diagnostics
- `<leader>cr`: References
- `<leader>cd`: Definitions
- `<leader>ct`: Type definitions
- `<leader>ci`: Implementations
- `<leader>cs`: Document symbols
- `<leader>cS`: Workspace symbols
- `<leader>hh`: Hoogle search

#### File Management
- `-`: NvimTree toggle
- `_`: Oil open

#### Terminal
- `<C-Space>`: FTerm toggle
- `<esc>`, `jk`: Terminal normal mode
- `<C-h/j/k/l>`: Terminal window navigation

#### Git
- `<leader>gg`: Neogit

#### Comments
- `<leader>cc`: Comment line
- `<leader>cb`: Comment block

#### Org-mode
- `<leader>t`: Todo cycle

## Key Differences and Missing Features

### Features Missing in New Config
From the perspective of a user coming from the old config, the new configuration lacks several features:

1. **Org-mode support**: The old config had extensive orgmode setup with custom todo keywords, highlighting, and integration. The new config has no org-mode support.

2. **Telescope fuzzy finder**: Replaced by Snacks picker, which may have different UX and fewer extensions (no project or hoogle extensions).

3. **Terminal management**: FTerm and toggleterm provided floating and persistent terminals. New config only has Snacks terminal.

4. **File explorer**: nvim-tree with extensive keybindings replaced by simpler Snacks explorer.

5. **Git interface**: Neogit provided a full git interface; new config only has gitsigns and lazygit integration.

6. **Snippets**: Luasnip for snippets not present in new config.

7. **Comment plugin**: Dedicated comment plugin not present (though treesitter may handle some).

8. **Oil file editing**: Direct file editing capabilities not present.

9. **File watching**: fwatch for auto-reloading files not present.

10. **Avante AI integration**: Commented out in old config but available.

### Plugins Replaced by Newer Equivalents

1. **nvim-cmp → blink.cmp**: Faster, more modern completion engine.

2. **telescope → snacks.picker**: Integrated picker with similar functionality but different API.

3. **nvim-tree → snacks.explorer**: Simpler, integrated explorer.

4. **neogit → snacks.lazygit**: Terminal-based git interface instead of Neovim buffer.

5. **FTerm/toggleterm → snacks.terminal**: Integrated terminal solution.

6. **Comment → mini.comment**: Treesitter-aware commenting.

7. **Traditional LSP setup → lze-managed LSP**: More declarative plugin loading.

The new configuration is more streamlined and modern, focusing on performance and integration, but may require users to adapt to new workflows for org-mode, advanced git operations, and fuzzy finding.


## Migration TODO

- [ ] Vim sleuth defaults - always force spaces, python, ...
- [ ] LSP keybindings
- [ ] LSPs - default to environment ones
    - [X] Python
- [ ] Documentation for all keybindings

- [ ] Clean up categories
- [ ] All the languages
    - [X] typescript, tailwind, svelte
    - [X] Python
    - [ ] Org mode / md?!
    - [ ] C / C++
    - [ ] Haskell
    - [ ] Nix
    - [ ] Lua


## Migration DONE

- [X] Comments: Old `<leader>cc`, `<leader>cb` (Comment plugin) → New `<leader>cc` (mini.comment)
- [X] Replace colon with comma for command mode: `map('n', ',', ':')` and `map('v', ',', ':')`, disable original colon: `map('n', ':', '<nop>')` and `map('v', ':', '<nop>')`
- [X] Add arrow key indentation: `<Left>` for `<<`, `<Right>` for `>>` in normal mode; `<Left>` for `<gv`, `<Right>` for `>gv` in visual mode
- [X] Disable accidental command history: `map('n', 'q:', '<nop>')` and `map('n', 'Q', '<nop>')`
- [X] Add cursor position remembering autocommand
- [X] Consider adding highlight on yank (already present) or other visual feedback

- [X] Terminal: Old `<C-Space>` (FTerm) → New `<C-Space>` (Snacks floating terminal) - same!
- [X] Git interface: Old `<leader>gg` (Neogit) → New `<leader>gg` (Snacks LazyGit) - remapped
- [X] File finder: Old `<leader>pf` (Telescope find_files) → New `<leader>ff` (Snacks files) - remapped
- [X] File explorer: Old `-` (nvim-tree) → New `-` (Snacks explorer) - same!
- [X] Find files with hidden: Old `<leader>pF` (Telescope) → New `<leader>fF` (Snacks git_files) - remapped
- [X] Live grep: Old `<leader>/` (Telescope) → New `<leader>/` (Snacks grep) - remapped
- [X] Buffer search: Old `<leader><leader>s` (custom?) → New `<leader>fs` (Snacks buffers) - remapped
- [X] Add filetype-specific indentation autocommands (2 spaces for js, ts, etc.) --> should be handled by vim-sleuth
- [X] Add sh filetype to disable expandtab --> let's see how vim-sleuth does this
- [X] Add Tab for fold toggle: `map('n', '<Tab>', 'za', { noremap = true })` -- obsolete

- [X] Open to right and below
- [X] On *, don't move to the next result
- [X] Auto-format on save
- [X] Toggling the floating terminal does not work in conjunction with another terminal

