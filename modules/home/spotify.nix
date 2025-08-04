{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (osConfig) wayland;
in
mkIf wayland.enable {
  # Set the default music client.
  env.MUSIC_CLIENT = "spotify";

  # Enable spotify, see: https://spotify.com/
  home.packages = builtins.attrValues {
    inherit (pkgs)
      spotify
      ;
  };
}
