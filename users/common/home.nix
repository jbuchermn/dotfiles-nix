input@{ config, pkgs, ... }:
let
  providePkgs = if builtins.hasAttr "providePkgs" input then input.providePkgs else true;
in
{
  imports = [
    ./home-minimal.nix
  ];

  fonts.fontconfig.enable = true;

  home.packages = (
    if providePkgs then
      with pkgs;
      [
        powerstat
        btop

        imv
        mpv

        adwaita-icon-theme
        vlc
        firefox
        chromium
        libreoffice
        spotify
      ]
    else
      [ ]
  );
}
