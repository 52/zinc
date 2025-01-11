{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    ghostty = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (builtins) attrValues;
      inherit (config) ghostty style env;
      inherit (style) colors;
    in
    mkIf ghostty.enable {
      home = {
        packages = attrValues {
          inherit (pkgs.unstable) ghostty;
        };
      };
      xdg = {
        configFile = {
          "ghostty/config" = {
            text = ''
              # theme 
              font-family = "monospace"
              font-style = light
              font-size = 16

              window-padding-x = 15
              window-padding-y = 10
              gtk-titlebar = false 

              background = ${colors.base00}
              foreground = ${colors.base05}

              # config
              copy-on-select = true

              # shell
              command = ${env.SHELL}

              # keybinds
              keybind = super+c=copy_to_clipboard
              keybind = super+v=paste_from_clipboard
              keybind = super+plus=increase_font_size:2
              keybind = super+minus=decrease_font_size:2
            '';
          };
        };
      };
    };
}
