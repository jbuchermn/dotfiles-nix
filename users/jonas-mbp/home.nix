input@{ config, pkgs, ... }:
let
  isWork = if builtins.hasAttr "isWork" input then input.isWork else false;
in
{
  programs.git = if isWork then {
    enable = true;
    settings.user.email = "jonas.bucher@mhp.com";
    settings.user.name = "Jonas Bucher";
  }else {
    enable = true;
    settings.user.email = "j.bucher.mn@gmail.com";
    settings.user.name = "Jonas Bucher";
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
