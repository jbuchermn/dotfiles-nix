{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  hardware.opengl.enable = true;

  # MBR on qemu 
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  # Networking
  networking.useDHCP = false;
  networking.interfaces.ens2.useDHCP = true;

  # Console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Names
  networking.hostName = "jb-nixos-qemu";
  users.users.jonas = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

}

