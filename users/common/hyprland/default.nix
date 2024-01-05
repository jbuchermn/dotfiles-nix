input@{ config, pkgs, ... }:
let
  providePkgs = if builtins.hasAttr "providePkgs" input then input.providePkgs else true;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      input = {
        kb_layout = "de,de";
        kb_model = "macintosh";
        kb_options = "caps:escape";
        follow_mouse = 1;

        touchpad = {
          natural_scroll = "yes";
          clickfinger_behavior = "yes";
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(92f0f5d1)";
        "col.inactive_border" = "rgba(59595933)";
      };

      decoration = {
        drop_shadow = false;
        rounding = 10;
        blur = {
          size = 5;
          passes = 3;
        };
      };

      misc = {
        force_default_wallpaper = 0;
      };

      "$mod" = "SUPER";
      bind = [
        "$mod, RETURN, exec, alacritty"
        "$mod, C, exec, chromium --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exit"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"


        "$mod, F, fullscreen"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
      ];

      exec-once = [
        "hyprpaper"
        "waybar"
      ];

      animation = [
        "windows,1,5,default"
        "workspaces,1,5,default"
      ];
    };
  };

  home.file."wallpaper.jpg".source = ../wallpaper.jpg;

  home.packages = with pkgs; [
    hyprpaper
    waybar
  ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/wallpaper.jpg
    wallpaper = ,~/wallpaper.jpg
  '';

  xdg.configFile."waybar/config".source = ./waybar/config;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;

  programs.zsh.loginExtra = ''
    [[ "$(tty)" == /dev/tty1 ]] && exec Hyprland
  '';
}
