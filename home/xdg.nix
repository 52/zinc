{ config, ... }:
let
  inherit (config) home;
  inherit (home) homeDirectory;
in
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      # core
      documents = "${homeDirectory}/Documents";
      download = "${homeDirectory}/Downloads";
      desktop = "${homeDirectory}/Desktop";
      # media
      pictures = "${homeDirectory}/Media/Images";
      videos = "${homeDirectory}/Media/Video";
      music = "${homeDirectory}/Media/Audio";
      # disable $XDG_PUBLICSHARE_DIR and $XDG_TEMPLATES_DIR
      extraConfig = {
        XDG_PUBLICSHARE_DIR = "/var/empty";
        XDG_TEMPLATES_DIR = "/var/empty";
      };
    };
  };
}
