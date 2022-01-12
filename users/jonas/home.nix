{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jonas Bucher";
    userEmail = "j.bucher.mn@gmail.com";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  imports = [
    ../common/home.nix
    ../common/zsh.nix
    ../common/alacritty.nix
    ../common/nvim.nix
    ../common/newm.nix
  ];

  programs.neomutt = {
    enable = true;
    vimKeys = true;
  };
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
  };
  programs.mbsync = {
    enable = true;
  };

  accounts.email.accounts.jbuchermn-gmail = {
    realName = "Jonas Bucher";
    signature.text = ''
      Viele Grüße
      Jonas
    '';

    primary = true;
    address = "j.bucher.mn@gmail.com";
    passwordCommand = "pass show gmail";

    userName = "j.bucher.mn@gmail.com";
    imap = {
      host = "imap.gmail.com";
      port = 993;
      tls.useStartTls = false;
    };

    smtp = {
      host = "smtp.gmail.com";
      port = 465;
    };

    mbsync = {
      enable = true;
      patterns = [
        "*" "!\"[Gmail]/All Mail\"" 
        "!\"[Gmail]/Important\"" 
        "!\"[Gmail]/Starred\""
        "!\"[Gmail]/Bin\""
      ];
      create = "both";
      expunge = "both";
    };
    notmuch.enable = true;
    neomutt.enable = true;
  };
}
