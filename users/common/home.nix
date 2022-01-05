{ config, pkgs, providePkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = if providePkgs then with pkgs; [
    powerstat
    rsync
    unzip
    zip
    tree
    neofetch

    powerline-fonts
    imv
    mpv

    brave
    chromium
    libreoffice
    zathura
  ] else [];
}
