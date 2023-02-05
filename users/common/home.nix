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

  home.file.".local/bin/home-manager-live-edit".source = ./shell/home-manager-live-edit.sh;
  home.file.".local/bin/nix-search".source = ./shell/nix-search.sh;
  home.file.".local/bin/gsync".source = ./shell/gsync.py;
  home.file.".local/bin/nix-flake-lock-nixpkgs".source = ./shell/nix-flake-lock-nixpkgs.sh;

  fonts.fontconfig.enable = true;

  # Basic
  home.packages = with pkgs; [
    neofetch
    unzip
    zip
    tree
    rsync

    nix-tree
    jq fzf # required by nix-search

  ] ++ (if providePkgs then with pkgs; [
    powerstat
    btop

    imv
    mpv

    gnome.adwaita-icon-theme
    vlc
    firefox
    chromium
    libreoffice
    spotify
  ] else []);
}
