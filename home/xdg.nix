{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    xdg = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config =
    let
      inherit (config) xdg home;
      inherit (home) homeDirectory;
    in
    mkIf xdg.enable {
      xdg = {
        inherit (xdg) enable;
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
    };
}
