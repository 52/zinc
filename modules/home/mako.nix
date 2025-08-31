{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (osConfig) wayland;
  inherit (config) theme;
in
mkIf wayland.enable {
  # Enable "mako".
  # See: https://github.com/emersion/mako
  services.mako.enable = true;

  # Manage the configuration file directly.
  # See: https://man.archlinux.org/man/mako.5.en
  xdg.configFile."mako/config".text = ''
    # Set the width.
    width=350

    # Set the padding.
    padding=10

    # Set the border size.
    border-size=2

    # Set the border radius.
    border-radius=3

    # Set the maximum visible notifications.
    max-visible=3

    # Set the default timeout.
    default-timeout=5000

    # Set the background color.
    background-color=#${theme.colors.background}

    # Set the foreground color.
    text-color=#${theme.colors.foreground}

    # Set the border color.
    border-color=#${theme.colors.focus}
  '';
}
