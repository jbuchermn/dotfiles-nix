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
          # https://github.com/NixOS/nixpkgs/tree/nixos-unstable/pkgs/development/tools/parsing/tree-sitter/grammars
          plugins: with plugins; [
            tree-sitter-python
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-bash
          ]
        ))

      FTerm-nvim

      vim-nix
    ]);
  };

  home.file.".local/bin/pylsp_wrapped".text = ''
      nix develop --command python3 -m pylsp || (>&2 echo "No valid nix development environment containing pylsp found - defaulting" && nvim-python3 -m pylsp)
    '';
  home.file.".local/bin/pylsp_wrapped".executable = true;
}
