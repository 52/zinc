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
  # Enable "Waybar".
  # See: https://github.com/Alexays/Waybar
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      modules-left = [
        "sway/workspaces"
      ];

      modules-center = [
        "custom/logo"
      ];

      modules-right = [
        "tray"
        "pulseaudio"
        "bluetooth"
        "network"
        "battery"
        "clock"
      ];

      "sway/workspaces" = {
        all-outputs = false;
        disable-scroll = true;
        format = "{index}";
      };

      tray = {
        spacing = 6;
        icon-size = 18;
        show-passive-items = true;
      };

      pulseaudio = {
        format = "{volume}%";
        format-muted = "Muted";
        format-bluetooth = "{volume}%";
        tooltip = false;
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      bluetooth = {
        format-on = "No Connection";
        format-off = "Offline";
        format-disabled = "Disabled";
        format-connected = "{num_connections}x";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        on-click = "${env.TERMINAL or "foot"} -e bluetoothctl";
      };

      network = {
        interval = 10;
        format-wifi = "{essid} ({signalStrength}%)";
        format-ethernet = "{ipaddr}";
        format-linked = "{ifname} (No IP)";
        format-disconnected = "Disconnected";
        tooltip = false;
        on-click = "${env.TERMINAL or "foot"} -e nmtui";
      };

      battery = {
        format = "{capacity}%";
        format-charging = "{capacity}%";
        format-plugged = "{capacity}%";
        tooltip = false;
      };

      clock = {
        interval = 60;
        format = "{:%H:%M - %d/%m/%y}";
        tooltip = false;
      };

      "custom/logo" = {
        format = "❆";
        tooltip = false;
      };
    };

    style = ''
      @define-color col-bg     #${theme.colors.background};
      @define-color col-fg     #${theme.colors.foreground};
      @define-color col-border #${theme.colors.border};
      @define-color col-focus  #${theme.colors.focus};
      @define-color col-dark   #${theme.colors.dark};
      @define-color col-hint   #${theme.colors.hint};

      * {
        font-family: monospace;
        font-weight: 500;
        font-size: 14px;

        border: none;
        border-radius: 0;
      }

      window#waybar {
        color: @col-fg;
        background: @col-bg;
        border-bottom: 2px solid @col-border;
      }

      #workspaces button.focused {
        background: @col-dark;
      }

      #tray, #pulseaudio, #bluetooth, #network, #battery, #clock {
        margin: 0.5rem 0.75rem;
        padding: 0.5rem 0.75rem;
        border-radius: 4px;
      }

      #pulseaudio:hover, #bluetooth:hover, #network:hover, #battery:hover, #clock:hover {
        background: @col-dark;
      }

      #tray {
        background: @col-dark;
      }

      #custom-logo {
        font-size: 1.75rem;
      }

      #waybar > box:nth-child(2) > box:nth-child(3) > *:not(:first-child) {
        background: linear-gradient(to bottom, transparent 30%, @col-dark 30%, @col-dark 70%, transparent 70%);
        background-repeat: no-repeat;
        background-size: 1px 100%;
        background-position: 0 0;
      }
    '';
  };
}
