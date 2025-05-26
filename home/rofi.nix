{ lib, config, ... }:
let
  inherit (lib) mkIf;
  inherit (config) hyprland;
in
mkIf hyprland.enable {
  programs =
    let
      inherit (config) style env;
      inherit (style) colors;
    in
    {
      rofi = {
        enable = true;
        font = "Berkeley Mono 14";
        terminal = env.TERMINAL;
        extraConfig = {
          display-drun = "";
          display-run = "󰞷";
          display-window = " ";
          modi = "window,run,drun";
          cycle = true;
          show-icons = true;
        };
        theme =
          let
            inherit (config.lib) formats;
            inherit (formats) rasi;
          in
          {
            "*" = {
              margin = rasi.mkLiteral "0";
              padding = rasi.mkLiteral "0";
              spacing = rasi.mkLiteral "0";
              text-color = rasi.mkLiteral colors.base05;
              background-color = rasi.mkLiteral "transparent";
            };
            "window" = {
              width = rasi.mkLiteral "768px";
              border = rasi.mkLiteral "2px";
              border-radius = rasi.mkLiteral "9px";
              border-color = rasi.mkLiteral colors.base02;
              background-color = rasi.mkLiteral colors.base00;
              children = map rasi.mkLiteral [
                "inputbar"
                "listview"
              ];
            };
            "inputbar" = {
              padding = rasi.mkLiteral "12px";
              spacing = rasi.mkLiteral "12px";
              border = rasi.mkLiteral "0 0 1px";
              border-color = rasi.mkLiteral colors.base02;
              children = map rasi.mkLiteral [
                "prompt"
                "entry"
              ];
            };
            "prompt, icon-search, entry, element-icon, element-text" = {
              vertical-align = rasi.mkLiteral "0.5";
            };
            "entry" = {
              font = "monospace 16";
              vertical-align = rasi.mkLiteral "0.5";
              placeholder = "Search...";
              placeholder-color = rasi.mkLiteral colors.base03;
            };
            "message" = {
              border = rasi.mkLiteral "2px 0 0";
              border-color = rasi.mkLiteral colors.base02;
            };
            "textbox" = {
              padding = rasi.mkLiteral "8px 24px";
            };
            "listview" = {
              lines = rasi.mkLiteral "10";
              columns = rasi.mkLiteral "1";
            };
            "element" = {
              padding = rasi.mkLiteral "8px 10px";
              spacing = rasi.mkLiteral "6px";
            };
            "element-icon" = {
              size = rasi.mkLiteral "1.5em";
            };
            "element selected normal, element selected active" = {
              background-color = rasi.mkLiteral colors.base02;
            };
          };
      };
    };
}
