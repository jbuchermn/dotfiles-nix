{ config, pkgs, isVirtual, providePkgs, ... }:
let 
  modText = if isVirtual then "mod = PYWM_MOD_ALT" else "";
in
{
  xdg.configFile."newm/config.py".text = ''
    ${builtins.readFile ./newm.py}
    ${modText}
  '';
  xdg.configFile."newm/launcher.py".text = ''
    entries = {
      "chromium": "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland",
      "firefox": "MOZ_ENABLE_WAYLAND=1 firefox",
      "nautilus": "nautilus",
      "spotify": "DISPLAY=\":0\" spotify",
      "alacritty": "alacritty",
    }

    shortcuts = {
      1: ("Chromium", "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland"),
      2: ("Firefox", "MOZ_ENABLE_WAYLAND=1 firefox"),
      3: ("Vim", "alacritty -e vim"),
      4: ("Nautilus", "nautilus")
    }
  '';

  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."rofi/config.rasi".source = ./rofi.rasi;

  home.packages = if providePkgs then with pkgs; [
    newm
    waybar
    wob
    nur.repos.kira-bruneau.rofi-wayland
    mako
    libnotify

    grim
    slurp

    gnome.nautilus
  ] else [];

  home.sessionVariables = if isVirtual then {
    WLR_NO_HARDWARE_CURSORS = 1; # Hardware cursors don't properly work inside qemu
  } else {};
}
