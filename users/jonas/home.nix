{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jonas Bucher";
    userEmail = "j.bucher.mn@gmail.com";
  };

  imports = [ ../common ];
}
