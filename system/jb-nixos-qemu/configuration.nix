{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common/default.nix
    ../common/user.nix
  ];

  # Hostname
  networking.hostName = "jb-nixos-qemu";

  # Boot
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  # Networking
  networking.useDHCP = false;
  networking.interfaces.ens2.useDHCP = true;

  # OpenGL
  hardware.opengl.enable = true;
}

