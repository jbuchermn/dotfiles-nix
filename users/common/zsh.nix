input@{ config, pkgs, ... }:
let
  providePkgs = if builtins.hasAttr "providePkgs" input then input.providePkgs else true;
  extraEnv = if builtins.hasAttr "extraEnv" input then input.extraEnv else "";
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    completionInit = ''
      autoload -U compinit && compinit -u
    '';
    shellAliases = {
      ll = "ls -lah";
      gco = "git checkout";
      gc = "git commit";
      gl = "git pull";
      glo = "git log";
      gp = "git push";
      gd = "git diff";
      ga = "git add";
      gst = "git status";

      # Old world
      nix-env = "echo \"Goodbye, old world.\"";
      nix-shell = "echo \"Goodbye, old world.\"";
      nix-build = "echo \"Goodbye, old world.\"";
      nix-channel = "echo \"Goodbye, old world.\"";
    };

    initContent = ''
      gcgh(){ git clone https://github.com/"$@" };

      eval "$(starship init zsh)"
      ${extraEnv}
    '';

    history = {
      share = false;
    };

    plugins = with pkgs; [
      {
        name = "zsh-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.6.0";
          sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
        };
        file = "zsh-syntax-highlighting.zsh";
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship =
    if providePkgs then {
      enable = true;
    } else { };

  xdg.configFile."starship/starship.toml".source = ./starship.toml;

  home.packages = with pkgs; [
    gemini-cli
  ];
}
