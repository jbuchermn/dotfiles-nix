{ config, pkgs, providePkgs, ... }:

{
  home.packages = with pkgs; [
    nixUnstable
  ];
  xdg.configFile."nix/nix.conf".text = ''
  experimental-features = nix-command flakes
  '';
}
