{ config, ... }:
{
  programs = {
    rofi = {
      enable = true;
      font = "monospace 14";
      terminal = config.home.sessionVariables.TERMINAL;
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
          inherit (config) lib home-style;
          inherit (lib.formats.rasi) mkLiteral;
        in
        with home-style;
        {
          "*" = {
            margin = mkLiteral "0";
            padding = mkLiteral "0";
            spacing = mkLiteral "0";
            text-color = mkLiteral colors.base05;
            background-color = mkLiteral "transparent";
          };
          "window" = {
            width = mkLiteral "768px";
            border = mkLiteral "1px";
            border-radius = mkLiteral "6px";
            border-color = mkLiteral colors.base02;
            background-color = mkLiteral colors.base00;
            children = map mkLiteral [
              "inputbar"
              "listview"
            ];
          };
          "inputbar" = {
            padding = mkLiteral "12px";
            spacing = mkLiteral "12px";
            border = mkLiteral "0 0 1px";
            border-color = mkLiteral colors.base02;
            children = map mkLiteral [
              "prompt"
              "entry"
            ];
          };
          "prompt, icon-search, entry, element-icon, element-text" = {
            vertical-align = mkLiteral "0.5";
          };
          "entry" = {
            font = "monospace 16";
            vertical-align = mkLiteral "0.5";
            placeholder = "Search...";
            placeholder-color = mkLiteral colors.base03;
          };
          "message" = {
            border = mkLiteral "2px 0 0";
            border-color = mkLiteral colors.base02;
          };
          "textbox" = {
            padding = mkLiteral "8px 24px";
          };
          "listview" = {
            lines = mkLiteral "10";
            columns = mkLiteral "1";
          };
          "element" = {
            padding = mkLiteral "8px 10px";
            spacing = mkLiteral "6px";
          };
          "element-icon" = {
            size = mkLiteral "1.5em";
          };
          "element selected normal, element selected active" = {
            background-color = mkLiteral colors.base02;
          };
        };
    };
  };
}
