{ config, pkgs, providePkgs, ... }:

{
  home.packages = with pkgs; [
    nixVersions.stable
  ];
  xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes
  '';
}
