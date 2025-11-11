{
  config,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    # Includes from installation-cd-base.nix
    (modulesPath + "/profiles/all-hardware.nix")
    (modulesPath + "/profiles/base.nix")
    (modulesPath + "/installer/scan/detected.nix")
    (modulesPath + "/installer/scan/not-detected.nix")

    ../common/default.nix
    # ../common/minimal.nix
  ];

  # Users
  users.users.jonas = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "input"
      "video"
    ];
    shell = pkgs.zsh;
    initialHashedPassword = "";
  };
  users.users.root.initialHashedPassword = "";
  services.getty.autologinUser = "jonas";
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Hostname
  networking.hostName = "jb-nixos-live";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
}
