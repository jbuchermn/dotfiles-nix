{ config, pkgs, ... }:
{
  imports = [
    ./minimal.nix
  ];

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
      config.common.default = "*";
    };
  };

}

