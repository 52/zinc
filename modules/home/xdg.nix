{
  config,
  ...
}:
{
  xdg = {
    enable = true;

    userDirs = {
      enable = true;

      # Automatically create directories.
      createDirectories = true;

      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      desktop = "${config.home.homeDirectory}/Desktop";

      pictures = "${config.home.homeDirectory}/Media/Images";
      videos = "${config.home.homeDirectory}/Media/Video";
      music = "${config.home.homeDirectory}/Media/Audio";

      # Disable $XDG_PUBLICSHARE_DIR and $XDG_TEMPLATES_DIR.
      extraConfig = {
        XDG_PUBLICSHARE_DIR = "/var/empty";
        XDG_TEMPLATES_DIR = "/var/empty";
      };
    };
  };

  # Force programs to adhere to the XDG Spec when possible.
  home.preferXdgDirectories = true;
}
