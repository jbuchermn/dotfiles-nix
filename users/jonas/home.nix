{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jonas Bucher";
    userEmail = "j.bucher.mn@gmail.com";
  };

  imports = [
    ../common/home.nix
    ../common/alacritty.nix
    ../common/nvim.nix
    ../common/newm.nix
  ];
}
