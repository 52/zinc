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
  # Enable "waybar".
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

      pulseaudio = {
        format = "{volume}%";
        format-muted = "MUTED";
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
      @define-color bar-bg #${theme.colors.background};
      @define-color bar-fg #${theme.colors.foreground};
      @define-color bar-border #${theme.colors.border};
      @define-color bar-focus #${theme.colors.focus};

      * {
        font-family: monospace;
        font-size: 14px;
        font-weight: 400;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        color: @bar-fg;
        background-color: @bar-bg;
        border-bottom: 1px solid @bar-border;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        margin: 0;
      }

      #pulseaudio,
      #bluetooth,
      #network,
      #battery,
      #clock {
        padding: 0.75rem 1rem;
        margin: 0 0.75rem;
        color: @bar-fg;
        background: transparent;
        transition: background 0.2s ease;
      }

      #pulseaudio:hover,
      #bluetooth:hover,
      #network:hover,
      #battery:hover,
      #clock:hover {
        background: @bar-border;
      }

      #custom-logo {
        font-size: 1.75rem;
        color: @bar-fg;
      }

      #waybar > box:nth-child(2) > box:nth-child(3) > *:not(:first-child) {
        background: linear-gradient(to bottom, transparent 30%, @bar-border 30%, @bar-border 70%, transparent 70%);
        background-repeat: no-repeat;
        background-size: 1px 100%;
        background-position: 0 0;
      }
    '';
  };
}
