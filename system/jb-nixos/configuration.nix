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

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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
  ];

}

