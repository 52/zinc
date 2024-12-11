{
  lib,
  config,
  mkOSLib,
  ...
}:
{
  options = {
    home-style = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enables the 'home-style' module.";
      };
      colors = {
        base01 = lib.mkOption {
          type = lib.types.str;
          default = "#0f0f0f";
          description = "Primary background color.";
        };
        base02 = lib.mkOption {
          type = lib.types.str;
          default = "#1d1d1d";
          description = "Secondary background color.";
        };
        base03 = lib.mkOption {
          type = lib.types.str;
          default = "#d9d9d9";
          description = "Primary foreground color.";
        };
        base04 = lib.mkOption {
          type = lib.types.str;
          default = "#5d5d5d";
          description = "Secondary foreground color.";
        };
      };
      wallpaper = {
        src = lib.mkOption {
          type = lib.types.str;
          default = mkOSLib.relativeToRoot "public/137242.png";
          description = "The wallpaper's source path.";
        };
        dest = lib.mkOption {
          type = lib.types.str;
          default = "${config.xdg.configHome}/hypr/wallpaper.png";
          description = "The wallpaper's destination path.";
        };
      };
    };
  };
  config =
    let
      inherit (config) home-style;
      options = home-style;
    in
    lib.mkIf options.enable {
      assertions = [
        {
          assertion = options.wallpaper.src != "";
          message = "home-style.wallpaper.src must not be empty.";
        }
        {
          assertion = options.wallpaper.dest != "";
          message = "home-style.wallpaper.dest must not be empty.";
        }
      ];
    };
}
