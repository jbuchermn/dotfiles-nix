{ config, pkgs, ... }:
{
  # User
  users.users.jonas = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "video"
      "libvirtd"
    ];
    shell = pkgs.zsh;
  };
}
