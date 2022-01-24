{ config, pkgs, ... }:

{
  imports =
    [
      ../common/default.nix
    ];

  # Hostname
  networking.hostName = "jb-nixos-live";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking: NetworkManager
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  # OpenGL
  hardware.opengl.enable = true;
}

