{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
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

    initExtra = ''
      gcgh(){ git clone https://github.com/"$@" };

      neofetch
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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  xdg.configFile."starship/starship.toml".source = ./starship.toml;
}
