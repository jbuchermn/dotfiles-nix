{ config, pkgs, ... }:
{
  programs.neomutt = {
    enable = true;
    vimKeys = true;
    sidebar = {
      enable = true;
      shortPath = false;
    };
    binds = [
      { map = [ "index" "pager" ]; key = "\\CK"; action = "sidebar-prev"; }
      { map = [ "index" "pager" ]; key = "\\CJ"; action = "sidebar-next"; }
      { map = [ "index" "pager" ]; key = "\\CL"; action = "sidebar-open"; }
      { map = [ "index" "pager" ]; key = "-"; action = "sidebar-toggle-visible"; }
    ];
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
        "*"
        "!\"[Gmail]/All Mail\"" 
        "!\"[Gmail]/Bin\""
      ];
      create = "both";
      expunge = "both";
    };
    notmuch.enable = true;
    neomutt = {
      enable = true;
      extraConfig = ''
        unmailboxes *
        mailboxes `\
        find /home/jonas/Maildir/jbuchermn-gmail -type d -print0 |\
            while IFS= read -r -d ${"''"} file; do\
                if [ -d "$file/cur" ]; then\
                    relfile=$(realpath --relative-to="/home/jonas/Maildir/jbuchermn-gmail" "$file");\
                    echo -n "=\"$relfile\" ";\
                fi\
            done`
      '';
    };
  };
}
