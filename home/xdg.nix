{ lib, config, ... }:
{
  options = {
    home-xdg = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables the 'home-xdg' module.";
      };
      enableUserDirs = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables the custom xdg directories.";
      };
    };
  };
  config = lib.mkIf config.home-xdg.enable {
    xdg = {
      enable = true;
      userDirs = lib.mkIf config.home-xdg.enableUserDirs {
        enable = true;
        createDirectories = true;
        # core
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        desktop = "${config.home.homeDirectory}/Desktop";
        # media
        pictures = "${config.home.homeDirectory}/Media/Images";
        videos = "${config.home.homeDirectory}/Media/Video";
        music = "${config.home.homeDirectory}/Media/Audio";
        # disable $XDG_PUBLICSHARE_DIR and $XDG_TEMPLATES_DIR
        extraConfig = {
          XDG_PUBLICSHARE_DIR = "/var/empty";
          XDG_TEMPLATES_DIR = "/var/empty";
        };
      };
    };
  };
}
