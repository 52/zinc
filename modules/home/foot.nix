{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config) theme;
  inherit (osConfig) wayland;
in
mkIf wayland.enable {
  # Set the default terminal.
  env.TERMINAL = "foot";

  # Enable foot, see: https://codeberg.org/dnkl/foot/
  programs.foot.enable = true;

  # Manage the configuration file directly.
  # See: https://man.archlinux.org/man/foot.ini.5.en/
  xdg.configFile."foot/foot.ini".text = ''
    [main]
    # Set the terminal font.
    font=monospace:size=16:weight=light

    # Set the font adjustment.
    font-size-adjustment=2px

    # Set the window padding.
    pad=8x8

    # Set the clipboard target.
    selection-target=both

    [key-bindings]
    # <SUPER> + C to copy to clipboard.
    clipboard-copy=Super+c

    # <SUPER> + P to paste from clipboard.
    clipboard-paste=Super+p

    # <SUPER> + "+" to increase the font size.
    font-increase=Super+plus

    # <SUPER> + "-" to decrease the font size.
    font-decrease=Super+minus

    [colors]
    # Set the background color.
    background=${theme.colors.background}

    # Set the foreground color.
    foreground=${theme.colors.foreground}
  '';
}
