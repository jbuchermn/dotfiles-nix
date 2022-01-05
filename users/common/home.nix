{ config, pkgs, providePkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = if providePkgs then with pkgs; [
    powerline-fonts
    imv
    mpv
    powerstat
    rsync
    unzip

    brave
    libreoffice
  ] else [];
}
