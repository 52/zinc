{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (osConfig) wayland;
in
mkIf wayland.enable {
  # Enable mako, see: https://github.com/emersion/mako/
  services.mako.enable = true;

  # Manage the configuration file directly.
  # See: https://man.archlinux.org/man/mako.5.en
  xdg.configFile."mako/config".text = ''
    # Set the maximum n of visible popups.
    max-visible=10
    # Set the default timeout.
    default-timeout=5000

    # Set the font.
    font=monospace 10
    # Set the padding.
    padding=10
    # Set the border size.
    border-size=1
    # Set the border radius.
    border-radius=5

    # Set the background color.
    background-color=#1c1c1c
    # Set the foreground color.
    text-color=#e8e8e8
  '';
}
