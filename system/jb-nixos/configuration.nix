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

    # Virtualisation
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
  ];

  # Virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  # Avahi
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # Disable firewall (for homekit)
  # networking.firewall.enable = false;

  # Cirrus CS4208 - not working
  # boot.extraModprobeConfig = ''
  #   options snd-hda-intel model=auto,mbp11
  # '';

  hardware.graphics = {
    enable = true;

    # Does not seem to be working properly, e.g. in Chrome
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # vaapiIntel # LIBVA_DRIVER_NAME=i965
      vaapiVdpau
      libvdpau-va-gl
    ];
  };


}

