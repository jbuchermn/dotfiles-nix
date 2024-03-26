{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
  };

  imports = [
    ../common/home.nix
    # ../common/home-minimal.nix

    ../common/zsh.nix
    ../common/nvim
    ../common/alacritty.nix
    ../common/hyprland
  ];
}
