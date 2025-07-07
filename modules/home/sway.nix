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
  # enable sway, see: https://swaywm.org/
  wayland.windowManager.sway = {
    enable = true;
  };
}
