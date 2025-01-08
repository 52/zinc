{ lib, config, ... }:
let
  inherit (lib) mkIf;
  inherit (config) hyprland style xdg;
  inherit (style) wallpaper;
in
mkIf hyprland.enable {
  home = {
    file = {
      "${xdg.configHome}/hypr/wallpaper.png" = {
        source = wallpaper;
      };
    };
  };
  services = {
    hyprpaper = {
      enable = true;
      settings = {
        wallpaper = [ "DP-1,${xdg.configHome}/hypr/wallpaper.png" ];
        preload = [ "${xdg.configHome}/hypr/wallpaper.png" ];
        splash = false;
      };
    };
  };
}
