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
          disable_loading_bar = true;
          hide_cursor = true;
          no_fade_in = true;
          grace = 0;
        };
        background = {
          path = wallpaper.dst;
          blur_passes = 2;
          brightness = 0.25;
        };
        input-field = {
          size = "250, 50";
          position = "0, -140";
          dots_center = true;
          fade_on_empty = false;
          inner_color = "rgb(${lib.strings.removePrefix "#" colors.base00})";
          outer_color = "rgb(${lib.strings.removePrefix "#" colors.base01})";
          font_color = "rgb(${lib.strings.removePrefix "#" colors.base05})";
          outline_thickness = 1;
          shadow_passes = 1;
          placeholder_text = "Enter Password ...";
        };
        image = [
          {
            path = profile.dst;
            size = "120";
            position = "0, -20";
            border_size = 1;
            border_color = "rgb(${lib.strings.removePrefix "#" colors.base01})";
            halign = "center";
            valign = "center";
          }
        ];
        label = [
          {
            text = "$TIME";
            color = "rgb(${lib.strings.removePrefix "#" colors.base05})";
            font_size = 200;
            position = "0, 300";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
