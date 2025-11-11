{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings.user.email = "j.bucher.mn@gmail.com";
    settings.user.name = "Jonas Bucher";
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
