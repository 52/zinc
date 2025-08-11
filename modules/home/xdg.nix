{
  config,
  ...
}:
{
  # Enable "XDG".
  # See: https://specifications.freedesktop.org/basedir-spec/latest
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;

      # Set the desktop directory.
      desktop = "${config.home.homeDirectory}/Desktop";

      # Set the download directory.
      download = "${config.home.homeDirectory}/Downloads";

      # Set the documents directory.
      documents = "${config.home.homeDirectory}/Documents";

      # Set the pictures directory.
      pictures = "${config.home.homeDirectory}/Media/Images";

      # Set the videos directory.
      videos = "${config.home.homeDirectory}/Media/Video";

      # Set the music directory.
      music = "${config.home.homeDirectory}/Media/Audio";

      extraConfig = {
        # Disable the "XDG_PUBLISHSHARE_DIR" directory.
        XDG_PUBLICSHARE_DIR = "/var/empty";

        # Disable the "XDG_TEMPLATES_DIR" directory.
        XDG_TEMPLATES_DIR = "/var/empty";
      };
    };
  };

  # Force programs to adhere to the "XDG" specification.
  home.preferXdgDirectories = true;
}
