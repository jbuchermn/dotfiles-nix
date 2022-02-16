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
      pylsp-mypy
      mypy
    ]);

    extraPackages = with pkgs; [
      ccls
      ripgrep

      haskell-language-server

      nodePackages.typescript nodePackages.typescript-language-server

      gcc # Necessary to compile tree-sitter plugins
    ];

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
            # tree-sitter-python  # still broken
            tree-sitter-c
            tree-sitter-cpp
            tree-sitter-bash
            tree-sitter-org-nvim
            tree-sitter-nix
            tree-sitter-haskell
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

  # Prevent errors on first startup (telescope-project e.g.)
  programs.zsh.initExtra = ''
    mkdir -p ~/.local/share/nvim
  '';
}
