{ config, pkgs, ... }:

{
  xdg.configFile."newm/config.py".source = ./newm.py;

  home.packages = [
    pkgs.newm
  ];

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = 1; # Hardware cursors don't properly work inside qemu
  };
}
