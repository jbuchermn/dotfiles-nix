{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings.user.email = "j.bucher.mn@gmail.com";
    settings.user.name = "Jonas Bucher";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  imports = [
    ../common/home.nix
    ../common/zsh.nix
    ../common/alacritty.nix
    ../common/nvim
    # ../common/newm
    ../common/hyprland
  ];

  home.packages = with pkgs; [
  ];
}
