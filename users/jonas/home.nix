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

  home.sessionPath = [ "$HOME/.local/bin" ];

  imports = [
    ../common/home.nix
    ../common/zsh.nix
    ../common/alacritty.nix
    ../common/nvim.nix
    ../common/newm.nix
  ];
}
