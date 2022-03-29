input@{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Jonas Bucher";
    userEmail = "j.bucher.mn@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.sessionPath = [ 
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
  ];

  imports = [
    ../common/home.nix
    ../common/zsh.nix
    ../common/alacritty.nix
    ../common/nvim.nix
    ../common/nix.nix
  ];

  home.packages = with pkgs; [
  ];
}
