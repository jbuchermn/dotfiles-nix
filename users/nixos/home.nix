{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
  };

  imports = [
    ../common/home-minimal.nix
    ../common/zsh.nix
    ../common/nvim

    # ../common/home.nix
    # ../common/alacritty.nix
    # ../common/newm
    # ../common/hyprland
  ];
}
