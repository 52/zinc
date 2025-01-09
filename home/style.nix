{ lib, ... }:
let
  inherit (lib) mkOption types custom;
  inherit (custom) relativeToRoot;
in
{
  options = {
    style = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enables the 'home/style' module.";
      };
      colors = {
        base00 = mkOption {
          type = types.str;
          default = "#111111";
          description = "Primary background color.";
        };
        base01 = mkOption {
          type = types.str;
          default = "#202020";
          description = "Background for inactive elements.";
        };
        base02 = mkOption {
          type = types.str;
          default = "#505050";
          description = "Background for selected, focused or active elements.";
        };
        base03 = mkOption {
          type = types.str;
          default = "#606060";
          description = "Comments, Invisibles, Line Highlighting";
        };
        base04 = mkOption {
          type = types.str;
          default = "#b0b0b0";
          description = "Foreground for inactive elements.";
        };
        base05 = mkOption {
          type = types.str;
          default = "#d9d9d9";
          description = "Primary foreground color.";
        };
      };
      wallpaper = mkOption {
        type = types.str;
        default = relativeToRoot "public/137242.png";
        description = "The wallpaper's source path.";
      };
      userImage = mkOption {
        type = types.str;
        default = relativeToRoot "public/359349.png";
        description = "The user's profile picture source path.";
      };
    };
  };
}
