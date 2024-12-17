{ lib, config, ... }:
let
  inherit (config) home-style;
  inherit (home-style) colors img;
  inherit (img) wallpaper profile;
in
{
  home = {
    file = {
      "${profile.dst}" = {
        source = profile.src;
      };
    };
  };
  programs = {
    hyprlock = {
      enable = true;
      settings = {
        general = {
          grace = 0;
          hide_cursor = true;
          disable_loading_bar = true;
        };
        background = {
          path = wallpaper.dst;
          blur_passes = 2;
          brightness = 0.25;
        };
        input-field = {
          size = "250, 50";
          position = "0, 80";
          dots_center = true;
          fade_on_empty = false;
          shadow_passes = 4;
          outline_thickness = 2;
          placeholder_text = "Enter Password ...";
          inner_color = "rgb(${lib.strings.removePrefix "#" colors.base00})";
          outer_color = "rgb(${lib.strings.removePrefix "#" colors.base01})";
          font_color = "rgb(${lib.strings.removePrefix "#" colors.base04})";
          halign = "center";
          valign = "bottom";
        };
        image = [
          {
            path = profile.dst;
            size = "140";
            position = "0, 160";
            border_size = 4;
            border_color = "rgb(${lib.strings.removePrefix "#" colors.base01})";
            halign = "center";
            valign = "bottom";
          }
        ];
        label = [
          {
            text = "<b>$TIME</b>";
            color = "rgb(${lib.strings.removePrefix "#" colors.base04})";
            font_size = 200;
            position = "0, -100";
            halign = "center";
            valign = "top";
          }
        ];
      };
    };
  };
}
