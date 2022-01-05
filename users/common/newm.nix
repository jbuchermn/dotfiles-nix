{ config, pkgs, isVirtual, providePkgs, ... }:
let 
  modText = if isVirtual then "mod = PYWM_MOD_ALT" else "";
in
{
  xdg.configFile."newm/config.py".text = ''
    ${builtins.readFile ./newm.py}
    ${modText}
  '';

  home.packages = if providePkgs then with pkgs; [
    newm
    waybar
    nur.repos.kira-bruneau.rofi-wayland
    mako
    libnotify
  ] else [];

  home.sessionVariables = if isVirtual then {
    WLR_NO_HARDWARE_CURSORS = 1; # Hardware cursors don't properly work inside qemu
  } else {};
}
