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
        "custom/separator"
        "bluetooth"
        "custom/separator"
        "network"
        "custom/separator"
        "battery"
        "custom/separator"
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

      "custom/separator" = {
        format = "|";
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
        font-size: 16px;
        font-weight: 300;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        color: @bar-fg;
        background-color: @bar-bg;
        border-bottom: 1px solid @bar-border;
      }

      #workspaces button,
      #pulseaudio,
      #bluetooth,
      #network,
      #battery,
      #clock {
        padding: 0.75rem 1rem;
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

      .modules-left,
      .modules-center,
      .modules-right {
        margin: 0;
      }

      #custom-logo {
        font-size: 1.5rem;
        color: @bar-fg;
      }

      #custom-separator {
        color: @bar-border;
        padding: 0 0.5px;
      }
    '';
  };
}
