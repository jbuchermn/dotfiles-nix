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

  # OpenGL and vaapi
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      (vaapiIntel.override { enableHybridCodec = true; }) # LIBVA_DRIVER_NAME=i965
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # MBP Webcam
  hardware.facetimehd.enable = true;

  environment.systemPackages = with pkgs; [
    # MBP Backlights
    brightnessctl

    # MBP Card Reader
    udisks2
  ];

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "jonas" ];

  # Guacamole
  services.guacamole = {
    enable = true;
    baseDir = "/var/guacamole";
    userMapping = ''
      <user-mapping>
        <authorize
          username="user"
          password="password">

          <connection name="localhost">
              <protocol>vnc</protocol>
              <param name="hostname">localhost</param>
              <param name="port">5900</param>
          </connection>
        </authorize>
      </user-mapping>
    '';
  };
}

