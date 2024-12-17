{ config, ... }:
let
  inherit (config) home-style;
in
{
  programs = {
    alacritty = {
      enable = true;
      settings = {
        font = {
          size = 16;
          normal = {
            family = "monospace";
            style = "Light";
          };
          offset = {
            x = 0;
            y = 2;
          };
        };
        window = {
          padding = {
            x = 10;
            y = 5;
          };
        };
        selection = {
          save_to_clipboard = true;
        };
        colors = with home-style; {
          primary = {
            background = colors.base00;
            foreground = colors.base05;
          };
        };
        keyboard = {
          bindings = [
            {
              key = "+";
              mods = "Super";
              action = "IncreaseFontSize";
            }
            {
              key = "-";
              mods = "Super";
              action = "DecreaseFontSize";
            }
          ];
        };
      };
    };
  };
}
