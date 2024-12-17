{
  config,
  ...
}:
let
  inherit (config) home-style;
  inherit (home-style) img;
  inherit (img) wallpaper;
in
{
  home = {
    file = {
      "${wallpaper.dst}" = {
        source = wallpaper.src;
      };
    };
  };
  services = {
    hyprpaper = {
      enable = true;
      settings = {
        wallpaper = [ "DP-1,${wallpaper.dst}" ];
        preload = [ "${wallpaper.dst}" ];
        splash = false;
      };
    };
  };
}
