{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common
    ];

  hardware.opengl.enable = true;

  # EFI on MBP
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # WiFi using NetworkManager
  networking.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.networkmanager.enable = true;

  # Sound - PA
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Sound (and screenshare) - PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ScreenShare on wlroots
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };
  };

  # MacBook Webcam
  hardware.facetimehd.enable = true;

  # Console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Names
  networking.hostName = "jb-nixos";
  users.users.jonas = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "video" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    pulseaudio
  ];

}

