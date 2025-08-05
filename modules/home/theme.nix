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
        description = "Default background color";
        default = "1c1c1c";
      };

      foreground = mkOption {
        type = types.str;
        description = "Default foreground color";
        default = "dedede";
      };
    };
  };
}
