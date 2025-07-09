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
  services.mako = {
    enable = true;
  };
}
