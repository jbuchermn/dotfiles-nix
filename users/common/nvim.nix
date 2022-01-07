{ config, pkgs, ... }:

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
      pylsp-mypy
      mypy
    ]);

    extraPackages = with pkgs; [
      ccls
      ripgrep

      nodePackages.typescript nodePackages.typescript-language-server

      gcc # Necessary to coompile tree-sitter plugins
    ];

    plugins = (with pkgs.vimPlugins; [
      oceanic-next

      orgmode

      nerdtree
      tcomment_vim
      vim-fugitive
      vim-gitgutter

      nvim-lspconfig
      lspsaga-nvim
      telescope-nvim

      (nvim-treesitter.withPlugins (
          # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars
          plugins: with plugins; [
            tree-sitter-python
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-bash
          ]
        ))

      vim-nix
    ]);
  };
}
