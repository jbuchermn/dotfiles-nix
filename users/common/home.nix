{ config, pkgs, providePkgs, ... }:

{
  programs.home-manager.enable = true;

  home.file.".local/bin/home-manager-quickcheck".source = ./shell/home-manager-quickcheck.sh;

  fonts.fontconfig.enable = true;
  home.packages = if providePkgs then with pkgs; [
    powerstat
    rsync
    unzip
    zip
    tree
    neofetch

    (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    imv
    mpv

    gnome.adwaita-icon-theme
    firefox
    chromium
    libreoffice
    zathura
  ] else [];
}
