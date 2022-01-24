{ config, pkgs, ... }:
{
  # User
  users.users.jonas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "video" ];
    shell = pkgs.zsh;
  };
}

