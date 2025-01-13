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
      inherit (config) ghostty style;
      inherit (config) xdg env;
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
              font-style = normal
              font-size = 16

              font-style-bold = false
              font-style-italic = false
              font-style-bold-italic = false

              window-padding-x = 8
              window-padding-y = 8
              gtk-titlebar = false 

              background = ${colors.base00}
              foreground = ${colors.base05}

              # config
              copy-on-select = true

              # shell
              command = ${xdg.configHome}/ghostty/start.sh

              # keybinds
              keybind = super+c=copy_to_clipboard
              keybind = super+v=paste_from_clipboard
              keybind = super+plus=increase_font_size:2
              keybind = super+minus=decrease_font_size:2
            '';
          };
          "ghostty/start.sh" = {
            text = ''
              #!${pkgs.bash}/bin/bash
              set -euo pipefail

              if ! command -v tmux >/dev/null 2>&1; then
                exec ${pkgs.${env.SHELL}}/bin/${env.SHELL}
              fi

              SESSION="ghostty"
              if tmux has-session -t "$SESSION" 2>/dev/null; then
                  exec tmux attach-session -t "$SESSION"
              else
                  exec tmux new-session -s "$SESSION"
              fi
            '';
            executable = true;
          };
        };
      };
    };
}
