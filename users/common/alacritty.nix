input@{ config, pkgs, ... }:
let
  providePkgs = if builtins.hasAttr "providePkgs" input then input.providePkgs else true;
  provideFont = if builtins.hasAttr "provideFont" input then input.provideFont else true;
in
{
  programs.alacritty = if providePkgs then {
    enable = true;
  } else {};

  home.packages = if provideFont then [
    (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ] else [];

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

window:
    opacity: 0.8

# macOS makes this necessary
# alt_send_esc: false
key_bindings:
- { key: Space, mods: Control, chars: "\x00" }
  '';
}
