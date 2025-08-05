{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.theme = {
    wallpaper = mkOption {
      type = types.path;
      description = "Path to the wallpaper file";
      default = lib.relativePath "local/assets/137242.png";
    };

    colors = {
      background = mkOption {
        type = types.str;
        description = "Color for the primary background";
        default = "1c1c1c";
      };

      foreground = mkOption {
        type = types.str;
        description = "Color for the primary foreground";
        default = "dedede";
      };

      border = mkOption {
        type = types.str;
        description = "Color for unfocused window borders/elements";
        default = "303030";
      };

      focus = mkOption {
        type = types.str;
        description = "Color for focused window borders/elements";
        default = "6c6c6c";
      };
    };
  };
}
