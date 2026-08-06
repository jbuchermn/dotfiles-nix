input@{ config, pkgs, name, email, ... }:
let
in
{
  programs.git =
      {
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
    ../common/nvim/basic.nix
    ../common/nix.nix
  ];

  home.packages = with pkgs; [
  ];
}
