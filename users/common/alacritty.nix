{ config, pkgs, providePkgs, ... }:

{
  programs.alacritty = if providePkgs then {
    enable = true;
  } else {};
  xdg.configFile."alacritty/alacritty.yml".text = ''
font:
    normal:
        family: SauceCodePro Nerd Font
        style: Regular
    bold:
        family: SauceCodePro Nerd Font
        style: Bold
    italic:
        family: SauceCodePro Nerd Font
        style: Italic
    bold_italic:
        family: SauceCodePro Nerd Font
        style: Bold Italic
    size: 8

background_opacity: 0.95

# macOS makes this necessary
alt_send_esc: false
key_bindings:
- { key: Space, mods: Control, chars: "\x00" }
  '';
}
