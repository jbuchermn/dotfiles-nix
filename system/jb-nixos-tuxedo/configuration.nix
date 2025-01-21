{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common/default.nix
      ../common/user.nix
    ];

  # Hostname
  networking.hostName = "jb-nixos-tuxedo";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking: NetworkManager
  networking.useDHCP = false;
  networking.interfaces.enp58s0f1.useDHCP = true;
  networking.interfaces.wlp59s0.useDHCP = true;
  networking.networkmanager.enable = true;

  # OpenGL
  hardware.graphics.enable = true;

  # Backlights
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

}

