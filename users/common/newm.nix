{ config, pkgs, ... }:

{
  xdg.configFile."newm/config.py".source = ./newm.py;
}
