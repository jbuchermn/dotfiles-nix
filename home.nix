{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jonas";
  home.homeDirectory = "/home/jonas";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      source ${./nvim.vim}
      luafile ${./nvim.lua}
    '';

    plugins = (with pkgs.vimPlugins; [
      oceanic-next

      nerdtree
      tcomment_vim
      vim-fugitive
      vim-gitgutter

      nvim-lspconfig
      lspsaga-nvim
      telescope-nvim

      vim-nix

    ]);
  };
}
