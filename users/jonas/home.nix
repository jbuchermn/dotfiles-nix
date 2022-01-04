{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jonas Bucher";
    userEmail = "j.bucher.mn@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  imports = [
    ../common/home.nix
    ../common/zsh.nix
    ../common/alacritty.nix
    ../common/nvim.nix
    ../common/newm.nix
  ];
}
