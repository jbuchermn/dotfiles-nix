{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common
    ];

  # Hostname
  networking.hostName = "jb-nixos";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking: NetworkManager
  networking.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.networkmanager.enable = true;

  # OpenGL
  hardware.opengl.enable = true;

  # MBP Webcam
  hardware.facetimehd.enable = true;

  # MBP Backlights
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

}

