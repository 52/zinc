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
    vscode = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
  config =
    let
      inherit (config) vscode;
    in
    mkIf vscode.enable {
      programs = {
        vscode = {
          enable = true;
          package = pkgs.unstable.vscode.override {
            commandLineArgs = [
              "--enable-features=UseOzonePlatform"
              "--ozone-platform-hint=auto"
              "--ozone-platform=wayland"
              "--enable-wayland-ime"
              "--gtk-version=4"
            ];
          };
          enableUpdateCheck = false;
          mutableExtensionsDir = false;
          enableExtensionUpdateCheck = false;
          extensions = with pkgs.vscode-marketplace; [
            # vim
            vscodevim.vim

            # editor
            aaron-bond.better-comments
            tomrijndorp.find-it-faster
            usernamehw.errorlens
            mkhl.direnv

            # debugger
            vadimcn.vscode-lldb

            # rust
            rust-lang.rust-analyzer
          ];
          userSettings = {
            # telemetry
            "telemetry.telemetryLevel" = "off";

            # keyboard
            "keyboard.dispatch" = "keyCode";

            # window
            "window.menuBarVisibility" = "hidden";
            "window.titleBarStyle" = "custom";

            # workbench
            "workbench.startupEditor" = "none";

            # editor
            "editor.fontFamily" = "SF Mono";
            "editor.fontWeight" = "normal";
            "editor.fontSize" = 16;

            "editor.minimap.enabled" = false;

            "editor.cursorBlinking" = "solid";
            "editor.formatOnSave" = true;

            # extensions
            "extensions.experimental.affinity" = {
              "vscodevim.vim" = 1;
            };

            # vim
            "vim.leader" = ",";
            "vim.useSystemClipboard" = true;
            "vim.normalModeKeyBindingsNonRecursive" = [
              {
                before = [
                  "<leader>"
                  "f"
                  "f"
                ];
                commands = [ "find-it-faster.findFiles" ];
              }
              {
                before = [
                  "<leader>"
                  "g"
                  "f"
                ];
                commands = [ "find-it-faster.findWithinFiles" ];
              }
              {
                before = [ "H" ];
                commands = [ "editor.action.showHover" ];
              }
            ];
          };
          keybindings = [
            {
              key = "meta+=";
              command = "editor.action.fontZoomIn";
            }
            {
              key = "meta+-";
              command = "editor.action.fontZoomOut";
            }
          ];
        };
      };
    };
}
