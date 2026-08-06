{ config, pkgs, name, email, ... }:
{
  programs.git = {
    enable = true;
    settings.user = { inherit email name; };
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
