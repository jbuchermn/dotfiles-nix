{ config, pkgs, name, email, ... }:
{
  programs.git = {
    enable = true;
    settings.user = { inherit email name; }
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
