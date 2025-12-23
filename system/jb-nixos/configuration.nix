{ config, pkgs, ... }:

{
  imports = [
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

    # GPU
    libva-utils # vainfo
    intel-gpu-tools # intel_gpu_top
    vdpauinfo

    # https://wiki.nixos.org/wiki/Chromium#Accelerated_video_playback
    (chromium.override {
      commandLineArgs = [
        "--enable-features=AcceleratedVideoEncoder,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL"
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
      ];
    })

    # audio debug
    pavucontrol
    alsa-utils
    alsa-tools

    # Virtualisation
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
  ];

  # Virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
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

    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      # intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libva-vdpau-driver
      libvdpau-va-gl # VDPAU_DRIVER=va_gl
    ];
  };

  environment.sessionVariables = { 
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
    NIXOS_OZONE_WL = "1";
  }; 


}
