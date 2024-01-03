{ config, pkgs, ... }:
{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  # Nix
  nix.extraOptions = ''
    experimental-features = nix-command flakes 
  '';

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Locale / Timezone
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  # Basic functionality
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    htop

    gnupg
    pass

    pulseaudio # pactl

    openvpn
  ];

  programs.zsh.enable = true;

  # GnuPG with fix
  programs = {
    gnupg.agent = {
      pinentryFlavor = "curses";
      enable = true;
    };
  };
  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
  '';

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

  # inotify watchers
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 1048576; # default:  8192
    "fs.inotify.max_user_instances" = 1024; # default:   128
    "fs.inotify.max_queued_events" = 32768; # default: 16384
  };
}

