{ config, pkgs, isMHP, ... }:

{
  programs.git = if isMHP then {
    enable = true;
    userName = "Jonas Bucher";
    userEmail = "jonas.bucher@mhp.com";
  } else {
    enable = true;
    userName = "Jonas Bucher";
    userEmail = "j.bucher.mn@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  imports = [
    ../common/home.nix
    ../common/zsh.nix
    ../common/alacritty.nix
    ../common/nvim.nix
  ];

  home.packages = with pkgs; [
    neofetch

    (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
}
