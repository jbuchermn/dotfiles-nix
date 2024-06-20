{ config, pkgs, lib, ... }:
let
  pluginGit = ref: rev: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
in
{
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;

    extraConfig = ":luafile ~/.config/nvim/lua/init.lua";

    extraPython3Packages = (ps: with ps; [
      python-lsp-server
      pylsp-mypy
      mypy
    ]);

    extraPackages = with pkgs; [
      ripgrep
      gcc # Necessary to compile tree-sitter plugins

      # Language-servers and utilities
      ccls

      haskell-language-server
      stylish-haskell

      nodePackages.typescript
      nodePackages.typescript-language-server

      nodePackages.purescript-language-server

      nodePackages.svelte-language-server
      nodePackages."@tailwindcss/language-server"

      lua-language-server

      nil
      nixpkgs-fmt

    ] ++ (if pkgs.stdenv.isLinux then [
      wl-clipboard

      # Language-servers and utilities
      dart # Install via brew on macOS
    ] else [ ]);

    plugins = (with pkgs.vimPlugins; [

      nvim-tree-lua
      nvim-web-devicons

      oceanic-next
      lualine-nvim

      comment-nvim
      nvim-ts-context-commentstring

      vim-fugitive
      neogit
      gitsigns-nvim

      oil-nvim

      orgmode
      headlines-nvim
      # neorg
      # (pluginGit "main" "3623e86e0fa6d07f45042f7207fc333c014bf167" "akinsho/org-bullets.nvim")

      nvim-lspconfig
      telescope-nvim
      telescope-project-nvim

      luasnip
      friendly-snippets

      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp
      cmp_luasnip


      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          tree-sitter-python
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-bash
          tree-sitter-nix
          tree-sitter-haskell
          tree-sitter-dart
          tree-sitter-svelte
          tree-sitter-javascript
          tree-sitter-typescript
          tree-sitter-html
          tree-sitter-css
          tree-sitter-lua
          tree-sitter-org
          tree-sitter-vimdoc
        ]
      ))

      FTerm-nvim

      # Language-specific plugins
      vim-nix
      stylish-haskell
      purescript-vim

    ] ++ (if pkgs.stdenv.isLinux then with pkgs.vimPlugins; [
      vim-wayland-clipboard
    ] else [ ]));
  };

  home.file.".local/bin/pylsp_wrapped".text = ''
    #!/usr/bin/env sh
    nix develop --command python3 -m pylsp "$@" || (>&2 echo "No valid nix development environment containing pylsp found - defaulting" && nvim-python3 -m pylsp "$@" )
  '';
  home.file.".local/bin/pylsp_wrapped".executable = true;

  home.file.".local/bin/hls_wrapped".text = ''
    #!/usr/bin/env sh
    nix develop --command "haskell-language-server-wrapper --lsp $@" || (>&2 echo "No valid nix development environment containing haskell-language-server found - defaulting" && haskell-language-server-wrapper --lsp "$@")
  '';
  home.file.".local/bin/hls_wrapped".executable = true;

  # Prevent errors on first startup (telescope-project e.g.)
  programs.zsh.initExtra = ''
    mkdir -p ~/.local/share/nvim
  '';
}
