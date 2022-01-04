{ config, pkgs, virtual-machine, ... }:
let 
  modText = if virtual-machine then "mod = PYWM_MOD_ALT" else "";
in
{
  xdg.configFile."newm/config.py".text = ''
    ${builtins.readFile ./newm.py}
    ${modText}
  '';

  home.packages = [
    pkgs.newm
  ];

  home.sessionVariables = if virtual-machine then {
    WLR_NO_HARDWARE_CURSORS = 1; # Hardware cursors don't properly work inside qemu
  } else {};
}
