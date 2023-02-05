input@{ config, pkgs, ... }:
let
  isWork = if builtins.hasAttr "isWork" input then input.isWork else false;
in
{
  programs.git = if isWork then {
    enable = true;
    userName = "Jonas Bucher";
    userEmail = "jonas.bucher@mhp.com";
  } else {
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
    ../common/nvim
    ../common/nix.nix
  ];

  home.packages = with pkgs; [
  ];
}
