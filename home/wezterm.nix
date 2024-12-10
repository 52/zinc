{ pkgs, config, ... }:
{
  programs = {
    wezterm =
      let
        shell = config.home.sessionVariables.SHELL;
      in
      {
        enable = true;
        enableZshIntegration = shell == "zsh";
        enableBashIntegration = shell == "bash";
        extraConfig = ''
                  -- vars
                  local wez = require("wezterm")
                  local config = wez.config_builder()

                  -- term
                  config.front_end = "WebGpu"
                  config.enable_wayland = false
                  config.webgpu_power_preference = "HighPerformance"
                  config.send_composed_key_when_left_alt_is_pressed = true
                  config.send_composed_key_when_right_alt_is_pressed = true

                  -- shell
                  config.default_prog = { '${pkgs.${shell}}/bin/${shell}', '-l' }

                  -- font
                  config.font_size = 20.0
                  config.font = wez.font("SF Mono", { weight = "Regular" })

                  -- window
                  config.window_padding = { left = 10, right = 10, top = 10, bottom = 0 }
                  config.window_background_opacity = 1.0
                  config.window_decorations = "RESIZE"

                  config.adjust_window_size_when_changing_font_size = false
                  config.window_close_confirmation = "NeverPrompt"
                  config.hide_mouse_cursor_when_typing = true

                  -- tabs
                  config.enable_tab_bar = false

                  -- binds
                  config.disable_default_key_bindings = true
                  config.keys = {
          	        { key = "+", mods = "SUPER", action = wez.action.IncreaseFontSize },
          	        { key = "-", mods = "SUPER", action = wez.action.DecreaseFontSize },
                  }

                  return config
        '';
      };
  };
}
