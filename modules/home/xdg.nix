{
  config,
  ...
}:
{
  xdg = {
    enable = true;

    userDirs = {
      enable = true;

      # automatically create directories
      createDirectories = true;

      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      desktop = "${config.home.homeDirectory}/Desktop";

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

  # force programs to use XDG directories (when possible)
  home.preferXdgDirectories = true;
}
