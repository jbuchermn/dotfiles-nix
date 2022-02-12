input@{ config, pkgs, ... }:
let
  providePkgs = if builtins.hasAttr "providePkgs" input then input.providePkgs else true;
in
{
  programs.home-manager.enable = true;

  home.sessionPath = [ "$HOME/.local/bin" ];
  home.sessionVariables = {
    EDITOR = "vim";
  };

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
    btop

    nix-tree
    jq fzf # required by nix-search

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
