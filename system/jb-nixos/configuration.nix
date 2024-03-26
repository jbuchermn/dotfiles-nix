{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common/default.nix
      ../common/user.nix
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

  # OpenGL and vaapi - not working
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # vaapiIntel # LIBVA_DRIVER_NAME=i965
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Cirrus CS4208 - not working
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=auto,mbp11
  '';

  # MBP Webcam
  hardware.facetimehd.enable = true;

  environment.systemPackages = with pkgs; [
    # MBP Backlights
    brightnessctl

    # MBP Card Reader
    udisks2

    # libva debug
    libva-utils

    # audio debug
    pavucontrol
    alsa-utils
    alsa-tools
  ];

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}

