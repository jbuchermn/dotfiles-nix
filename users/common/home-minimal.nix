{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.sessionPath = [ "$HOME/.local/bin" ];
  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.file.".local/bin/home-manager-live-edit".source = ./shell/home-manager-live-edit.sh;
  home.file.".local/bin/nix-search".source = ./shell/nix-search.sh;
  home.file.".local/bin/gsync".source = ./shell/gsync.py;
  home.file.".local/bin/nix-flake-lock-nixpkgs".source = ./shell/nix-flake-lock-nixpkgs.sh;
  home.file.".local/bin/nix-vim-nixpkgs".source = ./shell/nix-vim-nixpkgs.sh;

  # Basic
  home.packages = with pkgs; [
    neofetch
    unzip
    zip
    tree
    rsync

    nix-tree

    # nix-search
    jq
    fzf
  ];
}
