{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (osConfig) wayland;
  inherit (config) env;
in
mkIf wayland.enable {
  # Enable "rofi".
  # See: https://github.com/davatorium/rofi
  programs.rofi.enable = true;

  # Manage the configuration file directly.
  # See: https://man.archlinux.org/man/rofi-theme.5.en
  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
      /* Set the font. */
      font: "monospace 14";

      /* Set the default terminal. */
      terminal: "${env.TERMINAL}";
    }
  '';
}
