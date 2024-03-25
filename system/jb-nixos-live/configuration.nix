{ config, pkgs, ... }:

{
  imports =
    [
      # ../common/default.nix
      ../common/minimal.nix
    ];

  # User
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "video" ];
    shell = pkgs.zsh;
  };

  # Hostname
  networking.hostName = "jb-nixos-live";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking: NetworkManager
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
}

