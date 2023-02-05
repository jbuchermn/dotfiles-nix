{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
  };

  imports = [
    ../common/home.nix
    ../common/zsh.nix
    ../common/alacritty.nix
    ../common/nvim
    ../common/newm
  ];
}
