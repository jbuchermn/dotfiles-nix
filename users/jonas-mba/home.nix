input@{ config, pkgs, name, email, ... }:
{
  programs.git = {
    enable = true;
    settings.user = { inherit email name; };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
  ];

  imports = [
    ../common/home.nix
    ../common/zsh.nix
    ../common/alacritty.nix
    ../common/nvim
    ../common/nix.nix
  ];

  home.packages = with pkgs; [
  ];
}
