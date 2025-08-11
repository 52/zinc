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
      default = lib.relativePath "local/assets/137242.png";
      description = ''
        Path to the wallpaper file.

        This image will be used as the desktop background
        across all Wayland outputs.
      '';
    };

    colors = {
      background = mkOption {
        type = types.str;
        default = "1c1c1c";
        description = ''
          Color for the primary background.

          This color is used for terminal backgrounds and
          notification backgrounds in hexadecimal format.
        '';
      };

      foreground = mkOption {
        type = types.str;
        default = "dedede";
        description = ''
          Color for the primary foreground.

          This color is used for text and other foreground
          elements in hexadecimal format.
        '';
      };

      border = mkOption {
        type = types.str;
        default = "303030";
        description = ''
          Color for unfocused window borders.

          This color is applied to window borders when they
          are not actively focused in hexadecimal format.
        '';
      };

      focus = mkOption {
        type = types.str;
        default = "6c6c6c";
        description = ''
          Color for focused window borders.

          This color is applied to window borders when they
          are actively focused in hexadecimal format.
        '';
      };
    };
  };
}
