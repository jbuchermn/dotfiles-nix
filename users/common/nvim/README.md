# Neovim Configuration

This document describes the current Neovim configuration in `users/common/nvim/` and compares it to the old configuration in `users/common/nvim-old/`.

## Overview

The new configuration uses the `lze` plugin manager for lazy loading and is structured around categories of plugins (general, lua, nix, ...). It focuses on modern Neovim features with a clean, minimal setup.

### Categories and Plugins

#### Core Plugins (Startup)
- **lze**: Plugin manager for lazy loading
- **lzextras**: Extra utilities for lze
- **snacks.nvim**: Collection of small utilities (explorer, picker, terminal, etc.)
- **onedark**: Color scheme

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
- **nix**: nixd (Nix LSP)
- **typescript**: ts_ls, svelte, tailwindcss-language-server
- **python**: pylsp
- **c**: ccls
- **markdown**: render-markdown.nvim, opdavies-toggle-checkbox.nvim

### LSP Configuration

LSPs are configured using `nvim-lspconfig` and packaged via Nix. Servers are installed as Nix packages and made available at runtime through `lspsAndRuntimeDeps` and `extra` configurations in `default.nix`. They are enabled based on categories (e.g., `lua`, `nix`, `typescript`, `python`).

For Python (`pylsp`) and TypeScript/CSS/Svelte (`ts_ls`, `svelte`, `tailwindcss-language-server`) LSPs, the configuration first checks for executables in the development environment (e.g., via `vim.fn.executable`). If found, it uses the environment-provided versions; otherwise, it falls back to the standard Nix-packaged versions.

Supported languages and their LSP servers:
- **Lua**: `lua_ls` (with `lazydev.nvim` for enhanced support)
- **Nix**: `nixd`
- **TypeScript**: `ts_ls`
- **Svelte**: `svelte`
- **Python**: `pylsp`
- **C/C++**: `ccls`
- **Tailwind CSS**: `tailwindcss-language-server` (for HTML, CSS, Svelte)

Formatters (via `conform.nvim`) and linters (via `nvim-lint`) are similarly packaged and configured for supported languages.

### Keybindings

#### Groups
- `<leader><leader>`: Buffer commands
- `<leader>c`: Code
- `<leader>g`: Git
- `<leader>f`: Find (Snacks)
- `<leader>s`: Search (Snacks)

#### Basic Navigation
- `<Space>`: Leader key
- `<Esc>`: Clear search highlights
- `*`: Highlight without jumping
- `<C-j/k/l/h>`: Window navigation (normal and terminal mode)
- `n`, `N`: Next/previous search result with centering
- `J`, `K` (visual): Move lines down/up
- `k`, `j`: Navigate wrapped lines
- `,`: Enter command mode (easier than `:`)
- `<Left>`, `<Right>`: Indent left/right (normal mode)
- `<Left>`, `<Right>` (visual): Indent left/right and reselect
- `q:`, `Q`: Prevent accidental command history buffer (disabled)

#### Explorer
- `-`: Open explorer

#### Terminal
- `<c-space>`: Toggle floating terminal
- `<leader>tt`: Open terminal

#### Buffer Management
- `<leader><leader>[`, `<leader><leader>]`: Previous/next buffer
- `<leader><leader>l`: Last buffer
- `<leader><leader>d`: Delete buffer

#### Clipboard
- `<leader>y`: Yank to system clipboard
- `<leader>Y`: Yank line to system clipboard
- `<leader>p`: Paste from system clipboard
- `<C-p>` (insert): Paste from system clipboard
- `<leader>P` (visual): Paste over selection without erasing unnamed register

#### LSP
- `K`: Hover documentation
- `<leader>cr`: Rename
- `<leader>ca`: Code action
- `<leader>sr`: Search references (via Snacks picker)
- `<leader>si`: Search implementation (via Snacks picker)
- `<leader>ss`: Search symbols (via Snacks picker)
- `<leader>sd`: Search definition
- `<leader>se`: Search declaration
- `<leader>st`: Search type definition
- `<leader>sD`: Search diagnostics
- `<leader>sB`: Search diagnostics in buffer

#### Completion (blink.cmp)
- `<C-j>`: Select next
- `<C-k>`: Select previous
- `<Tab>`: Accept
- `<C-e>`: Hide

#### Diagnostics
- `<leader>sD`: Search diagnostics (all)
- `<leader>sB`: Search diagnostics in buffer

#### Git
- `<leader>gg`: Open LazyGit
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

#### Markdown
- `<CR>`: Toggle checkbox

#### Snacks
- `<leader>fs`: Find buffers
- `<leader>ff`: Find files
- `<leader>fF`: Find files (git)
- `<leader>sb`: Search / grep buffer lines
- `<leader>sB`: Search / grep open buffers
- `<leader>/`: Grep
- `<leader>sh`: Search help pages
- `<leader>sk`: Search keymaps
- `<leader>sM`: Search man pages
- `<leader>sR`: Search: resume
- `<leader>su`: Search undo history

#### Debugging (DAP)
- `<F5>`: Start/Continue
- `<F1>`: Step Into
- `<F2>`: Step Over
- `<F3>`: Step Out
- `<leader>b`: Toggle breakpoint
- `<leader>B`: Set breakpoint with condition
- `<F7>`: Toggle DAP UI

#### Formatting/Linting
- `<leader>cf`: Format file (conform.nvim)


## Migration TODO

- [ ] Test DAP
- [ ] fwatch for markdown
- [ ] Test vim-sleuth vs forced defaults (always spaces for python etc)


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

- [X] LSPs - default to environment ones
    - [X] Python
    - [X] typescript, tailwind, svelte
    - [X] C/C++

- [X] LSP keybindings
- [X] All the languages
    - [X] typescript, tailwind, svelte
    - [X] Python
    - [X] Markdown
    - [X] Nix
    - [X] Lua
    - [X] C / C++
