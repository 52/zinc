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
        base00 = lib.mkOption {
          type = lib.types.str;
          default = "#111111";
          description = "Primary background color.";
        };
        base01 = lib.mkOption {
          type = lib.types.str;
          default = "#202020";
          description = "Background for inactive elements.";
        };
        base02 = lib.mkOption {
          type = lib.types.str;
          default = "#505050";
          description = "Background for selected, focused or active elements.";
        };
        base03 = lib.mkOption {
          type = lib.types.str;
          default = "#606060";
          description = "Comments, Invisibles, Line Highlighting";
        };
        base04 = lib.mkOption {
          type = lib.types.str;
          default = "#b0b0b0";
          description = "Foreground for inactive elements.";
        };
        base05 = lib.mkOption {
          type = lib.types.str;
          default = "#d9d9d9";
          description = "Primary foreground color.";
        };
      };
      img = {
        wallpaper = {
          src = lib.mkOption {
            type = lib.types.str;
            default = mkOSLib.relativeToRoot "public/137242.png";
            description = "The wallpaper's source path.";
          };
          dst = lib.mkOption {
            type = lib.types.str;
            default = "${config.xdg.configHome}/hypr/wallpaper.png";
            description = "The wallpaper's destination path.";
          };
        };
        profile = {
          src = lib.mkOption {
            type = lib.types.str;
            default = mkOSLib.relativeToRoot "public/359349.png";
            description = "The user's profile picture source path.";
          };
          dst = lib.mkOption {
            type = lib.types.str;
            default = "${config.xdg.configHome}/hypr/profile.png";
            description = "The user's profile picture destination path.";
          };
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
          assertion = options.img.wallpaper.src != "";
          message = "home-style.img.wallpaper.src must not be empty.";
        }
        {
          assertion = options.img.wallpaper.dst != "";
          message = "home-style.img.wallpaper.dst must not be empty.";
        }
        {
          assertion = options.img.profile.src != "";
          message = "home-style.img.profile.src must not be empty.";
        }
        {
          assertion = options.img.profile.dst != "";
          message = "home-style.img.profile.dst must not be empty.";
        }
      ];
    };
}
