{ config, pkgs, providePkgs, ... }:

{
  home.packages = with pkgs; [
    nixFlakes
  ];
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';
}
