{
  config,
  ...
}:
let
  inherit (config) home-style;
in
{
  home = {
    file = {
      "${home-style.wallpaper.dest}" = {
        source = home-style.wallpaper.src;
      };
    };
  };
  services = {
    hyprpaper = {
      enable = true;
      settings = {
        wallpaper = [ "DP-1,${home-style.wallpaper.dest}" ];
        preload = [ "${home-style.wallpaper.dest}" ];
        splash = false;
      };
    };
  };
}
