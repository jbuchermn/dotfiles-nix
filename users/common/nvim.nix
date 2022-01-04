{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = builtins.readFile ./nvim.vim;

    extraPython3Packages = (ps: with ps; [
      python-lsp-server
      pylsp-mypy
    ]);

    plugins = (with pkgs.vimPlugins; [
      oceanic-next

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
