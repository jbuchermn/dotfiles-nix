{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.powerline-fonts
  ];
}
