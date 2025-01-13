{ lib, ... }:
let
  inherit (lib) mkOption types custom;
  inherit (custom) relativeToRoot;
in
{
  options = {
    style = {
      colors = {
        base00 = mkOption {
          type = types.str;
          default = "#141414";
          description = ''
            Default background color used in the scheme.
          '';
        };
        base01 = mkOption {
          type = types.str;
          default = "#242424";
          description = ''
            Lighter background for UI elements and emphasized content.
          '';
        };
        base02 = mkOption {
          type = types.str;
          default = "#3b3b3b";
          description = ''
            Selection background and highlighted content.
          '';
        };
        base03 = mkOption {
          type = types.str;
          default = "#5e5e5e";
          description = ''
            Comments, invisibles, and line highlighting.
          '';
        };
        base04 = mkOption {
          type = types.str;
          default = "#b0b0b0";
          description = ''
            Foreground for inactive and secondary UI elements.
          '';
        };
        base05 = mkOption {
          type = types.str;
          default = "#d9d9d9";
          description = ''
            Default foreground and primary content color.
          '';
        };
        base06 = mkOption {
          type = types.str;
          default = "#e0e0e0";
          description = ''
            Lighter foreground color for emphasis and highlights.
          '';
        };
        base07 = mkOption {
          type = types.str;
          default = "#f5f5f5";
          description = ''
            Brightest foreground color for special emphasis.
          '';
        };
        base08 = mkOption {
          type = types.str;
          default = "#da0b0b";
        };
        base09 = mkOption {
          type = types.str;
          default = "#ff9166";
        };
        base0A = mkOption {
          type = types.str;
          default = "#ebc746";
        };
        base0B = mkOption {
          type = types.str;
          default = "#9cc587";
        };
        base0C = mkOption {
          type = types.str;
          default = "#12cfc0";
        };
        base0D = mkOption {
          type = types.str;
          default = "#c8f0f7";
        };
        base0E = mkOption {
          type = types.str;
          default = "#e876e0";
        };
        base0F = mkOption {
          type = types.str;
          default = "#deaf8f";
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
