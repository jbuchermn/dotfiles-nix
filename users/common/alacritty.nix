{ config, pkgs, providePkgs, ... }:

{
  programs.alacritty = if providePkgs then {
    enable = true;
  } else {};
  xdg.configFile."alacritty/alacritty.yml".text = ''
font:
    normal:
        family: Source Code Pro for Powerline
        style: Regular
    bold:
        family: Source Code Pro for Powerline
        style: Bold
    italic:
        family: Source Code Pro for Powerline
        style: Italic
    bold_italic:
        family: Source Code Pro for Powerline
        style: Bold Italic
    size: 8

background_opacity: 0.9
  '';
}
