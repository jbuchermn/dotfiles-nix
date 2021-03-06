{ config, pkgs, lib, ... }:
let
  pluginGit = ref: rev: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
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
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;

    extraConfig = builtins.readFile ./nvim.vim;

    extraPython3Packages = (ps: with ps; [
      python-lsp-server
      (pylsp-mypy.overrideAttrs (old: { pytestCheckPhase = "true"; }))
      mypy
    ]);

    extraPackages = with pkgs; [
      ripgrep
      gcc # Necessary to compile tree-sitter plugins

      # Language-servers and utilities
      ccls

      (haskell-language-server.override { supportedGhcVersions = [ "8107" ]; })
      stylish-haskell

      nodePackages.typescript nodePackages.typescript-language-server

      nodePackages.purescript-language-server

    ] ++ (if pkgs.stdenv.isLinux then [
      wl-clipboard

      # Language-servers and utilities
      dart  # Install via brew on macOS
    ] else []);

    plugins = (with pkgs.vimPlugins; [
      neon

      orgmode
      (pluginGit "main" "73407e765c65006bf1f7740e8d4fb4450a82aa0b" "akinsho/org-bullets.nvim")

      nerdtree
      tcomment_vim
      vim-fugitive
      neogit

      nvim-lspconfig
      lspsaga-nvim
      telescope-nvim
      telescope-project-nvim

      nvim-cmp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp

      vim-vsnip
      cmp-vsnip

      (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-python
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-bash
            tree-sitter-nix
            tree-sitter-haskell
            tree-sitter-dart
          ]
        ))

      FTerm-nvim

      # Language-specific plugins
      vim-nix
      stylish-haskell
      purescript-vim

    ] ++ (if pkgs.stdenv.isLinux then with pkgs.vimPlugins; [
      vim-wayland-clipboard
    ] else []));
  };

  home.file.".local/bin/pylsp_wrapped".text = ''
      nix develop --command python3 -m pylsp || (>&2 echo "No valid nix development environment containing pylsp found - defaulting" && nvim-python3 -m pylsp)
    '';
  home.file.".local/bin/pylsp_wrapped".executable = true;

  # Prevent errors on first startup (telescope-project e.g.)
  programs.zsh.initExtra = ''
    mkdir -p ~/.local/share/nvim
  '';
}
