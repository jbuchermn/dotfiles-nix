{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

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

  programs.alacritty = {
    enable = true;
  };
  xdg.configFile."alacritty/alacritty.yml".text = ''
font:
    normal:
        family: Source Code Pro for Powerline
        style: Regular
    bold:
        family: Source Code Pro for Powerline
        style: Bold
    italic:
        family: Source Code Pro for Powerline
        style: Italic
    bold_italic:
        family: Source Code Pro for Powerline
        style: Bold Italic
    size: 8

background_opacity: 0.9
  '';

  home.packages = [
    pkgs.powerline-fonts
  ];
}
