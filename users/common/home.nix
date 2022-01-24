input@{ config, pkgs, ... }:
let
  providePkgs = if builtins.hasAttr "providePkgs" input then input.providePkgs else true;
in
{
  programs.home-manager.enable = true;

  home.file.".local/bin/home-manager-quickcheck".source = ./shell/home-manager-quickcheck.sh;
  home.file.".local/bin/nix-search".source = ./shell/nix-search.sh;

  fonts.fontconfig.enable = true;
  home.packages = if providePkgs then with pkgs; [
    powerstat
    rsync
    unzip
    zip
    tree
    neofetch

    nix-tree

    (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    imv
    mpv

    gnome.adwaita-icon-theme
    vlc
    firefox
    chromium
    libreoffice
    spotify
  ] else [];
}
