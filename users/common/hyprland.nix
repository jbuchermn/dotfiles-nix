input@{ config, pkgs, ... }:
let
  providePkgs = if builtins.hasAttr "providePkgs" input then input.providePkgs else true;
in
{
  home.packages =
    if providePkgs then with pkgs; [
      hyprland
    ] else [ ];
}
