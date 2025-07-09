{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (osConfig) wayland;
  env = config.env;
in
mkIf wayland.enable {
  # Enable rofi, see: https://github.com/davatorium/rofi/
  programs.rofi = {
    enable = true;

    # Set default font.
    font = "monospace 14";

    # Set default terminal.
    terminal = env.TERMINAL;
  };
}
