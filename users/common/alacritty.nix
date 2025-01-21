input@{ config, pkgs, ... }:
let
  providePkgs = if builtins.hasAttr "providePkgs" input then input.providePkgs else true;
in
{
  programs.alacritty =
    if providePkgs then {
      enable = true;
    } else { };

  home.packages = [
    pkgs.nerd-fonts.sauce-code-pro
  ];

  xdg.configFile."alacritty/alacritty.toml".text = ''
    [font]
    size = 8

    [font.bold]
    family = "SauceCodePro Nerd Font"
    style = "Bold"

    [font.bold_italic]
    family = "SauceCodePro Nerd Font"
    style = "Bold Italic"

    [font.italic]
    family = "SauceCodePro Nerd Font"
    style = "Italic"

    [font.normal]
    family = "SauceCodePro Nerd Font"
    style = "Regular"

    [[keyboard.bindings]]
    chars = "\u0000"
    key = "Space"
    mods = "Control"

    [window]
    opacity = 0.8
  '';
}
