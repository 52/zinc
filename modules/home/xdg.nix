{
  config,
  ...
}:
{
  # Enable xdg, see: https://specifications.freedesktop.org/basedir-spec/latest/
  xdg = {
    enable = true;

    userDirs = {
      enable = true;

      # Automatically create directories.
      createDirectories = true;

      # Set the user directories.
      desktop = "${config.home.homeDirectory}/Desktop";
      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";

      # Set the media directories.
      videos = "${config.home.homeDirectory}/Media/Video";
      music = "${config.home.homeDirectory}/Media/Audio";
      pictures = "${config.home.homeDirectory}/Media/Images";

      extraConfig = {
        # Disable the $XDG_PUBLISHSHARE_DIR directory.
        XDG_PUBLICSHARE_DIR = "/var/empty";

        # Disable the $XDG_TEMPLATES_DIR directory.
        XDG_TEMPLATES_DIR = "/var/empty";
      };
    };
  };

  # Force programs to adhere to the XDG Spec when possible.
  home.preferXdgDirectories = true;
}
