input@{ config, pkgs, ... }:
let
  isVirtual = if builtins.hasAttr "isVirtual" input then input.isVirtual else false;
  isMBP = if builtins.hasAttr "isMBP" input then input.isMBP else true;
  providePkgs = if builtins.hasAttr "providePkgs" input then input.providePkgs else true;

  confFile = builtins.replaceStrings
    [ "PLACEHOLDER_xkb_model" "PLACEHOLDER_mod" "PLACEHOLDER_c_gestures" "PLACEHOLDER_pyevdev_gestures" ]
    [
      (if isMBP then "macintosh" else "de-latin1")
      (if isVirtual then "A" else "L")
      (if isMBP then "{'enabled': False}" else "{'enabled': True, 'scale_px': 800.}")
      (if isMBP then "{'enabled': True}" else "{'enabled': False}")
    ]
    (builtins.readFile ./config.py);
in
{
  xdg.configFile."newm/config.py".text = confFile;
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

  xdg.configFile."mako/config".text = ''
    layer=overlay
    background-color=#0D2D2A
    default-timeout=5000
    border-size=0
    border-radius=12
  '';

  xdg.configFile."newm/wob.ini".text = ''
    anchor = bottom
    margin = 100
  '';

  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."rofi/config.rasi".source = ./rofi.rasi;

  home.packages =
    if providePkgs then with pkgs; [
      newm
      waybar
      wob
      rofi-wayland
      mako
      libnotify

      pywm-fullscreen

      grim
      slurp

      gnome.nautilus

      sway
    ] else [ ];

  home.sessionVariables =
    if isVirtual then {
      WLR_NO_HARDWARE_CURSORS = 1; # Hardware cursors don't properly work inside qemu
    } else { };

  home.file."wallpaper.jpg".source = ../wallpaper.jpg;

  programs.zsh.loginExtra = ''
    [[ "$(tty)" == /dev/tty1 ]] && start-newm
  '';
}
