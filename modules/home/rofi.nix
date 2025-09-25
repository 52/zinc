{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config) theme env;
  inherit (osConfig) wayland;
in
mkIf wayland.enable {
  # Enable "rofi".
  # See: https://github.com/davatorium/rofi
  programs.rofi.enable = true;

  # Manage the configuration file directly.
  # See: https://man.archlinux.org/man/rofi.1.en
  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
      font: "monospace 14";
      terminal: "${env.TERMINAL}";
      display-drun: "";
      display-run: "";
    }

    * {
      col-bg:     #${theme.colors.background};
      col-fg:     #${theme.colors.foreground};
      col-border: #${theme.colors.border};
      col-focus:  #${theme.colors.focus};
      col-hint:   #${theme.colors.hint};
      col-dark:   #${theme.colors.dark};
    } 

    window {
      width: 20%;

      font: inherit;
      text-color: @col-fg;

      border: 2px solid;
      border-radius: 3px;
      border-color: @col-border;

      background-color: @col-bg;

      children: [ "inputbar", "listview" ];
    }

    inputbar {
      font: inherit;
      text-color: inherit;

      padding: 0.25em 0.5em;
      spacing: 0.35em;

      border: 0 0 1px;
      border-color: @col-border;

      background-color: transparent;

      children: [ "prompt", "entry"];
    }

    prompt {
      font: inherit;
      text-color: inherit;
    }

    entry {
      placeholder: "Search...";
      placeholder-color: @col-hint;
    }

    listview {
      font: inherit;
      text-color: inherit;

      border: 0;
      border-radius: 0px;

      background-color: transparent;

      lines: 6;
      fixed-height: true;
    }

    scrollbar {
      handle-width: 4px;
      handle-color: @col-fg;

      background-color: @col-dark;
    }

    element {
      font: inherit;
      text-color: inherit;

      padding: 0.25em 0.5em;
      spacing: 0.35em;

      border: 0 0 1px;
      border-color: @col-border;

      background-color: transparent;
    }

    element normal.normal, element alternate.normal {
      text-color: inherit;
      background-color: inherit;
    }

    element selected.normal {
      text-color: inherit;
      background-color: @col-hint;
    }

    element-icon, element-text, prompt, entry {
      text-color: inherit;
      background-color: transparent;
      vertical-align: 0.5;
    }

    element-icon {
      size: 1.5em;
    }
  '';
}
