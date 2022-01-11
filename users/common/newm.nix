{ config, pkgs, isVirtual, providePkgs, ... }:
let 
  modText = if isVirtual then "mod = PYWM_MOD_ALT" else "";
in
{
  xdg.configFile."newm/config.py".text = ''
    ${builtins.readFile ./newm.py}
    ${modText}
  '';

  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."rofi/config.rasi".source = ./rofi.rasi;

  home.packages = if providePkgs then with pkgs; [
    newm
    waybar
    nur.repos.kira-bruneau.rofi-wayland
    mako
    libnotify

    grim
    slurp
  ] else [];

  home.sessionVariables = if isVirtual then {
    WLR_NO_HARDWARE_CURSORS = 1; # Hardware cursors don't properly work inside qemu
  } else {};
}
