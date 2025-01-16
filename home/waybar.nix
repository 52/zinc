{ lib, config, ... }:
let
  inherit (lib) mkIf;
  inherit (config) hyprland style env;
  inherit (style) colors;
in
mkIf hyprland.enable {
  programs = {
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 47;
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-center = [ "custom/logo" ];
          modules-right = [
            "tray"
            "custom/separator"
            "cpu"
            "custom/separator"
            "pulseaudio"
            "custom/separator"
            "bluetooth"
            "custom/separator"
            "network"
            "custom/separator"
            "clock"
          ];
          "hyprland/workspaces" = {
            "all-outputs" = true;
            "on-click" = "activate";
          };
          "cpu" = {
            "interval" = 10;
            "format" = "{usage}% CPU";
            "tooltip" = false;
            "on-click" = "${env.TERMINAL} -e btop";
          };
          "pulseaudio" = {
            "format" = "{volume}% VOL";
            "format-muted" = "MUTE";
            "tooltip-format" = "Current Sink: {desc}";
          };
          "bluetooth" = {
            "format-on" = "󰂯 No Connection";
            "format-off" = "󰂲 Offline";
            "format-disabled" = "󰂯 Disabled";
            "format-connected" = "{num_connections}x 󰂯";
            "tooltip-format-connected" = "{device_enumerate}";
            "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
            "on-click" = "${env.TERMINAL} -e bluetoothctl";
          };
          "network" = {
            "interval" = 10;
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ipaddr} ";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = "Disconnected";
            "tooltip" = false;
            "on-click" = "${env.TERMINAL} -e nmtui";
          };
          "clock" = {
            "interval" = 10;
            "format" = "{:%H:%M - %d/%m/%y}";
            "tooltip" = false;
          };
          "custom/separator" = {
            "format" = "│";
            "interval" = "once";
            "tooltip" = false;
          };
          "custom/logo" = {
            "format" = "❆";
            "interval" = "once";
            "tooltip" = false;
          };
          "tray" = {
            "spacing" = 10;
            "icon-size" = 21;
            "show-passive-items" = true;
          };
        };
      };
      style = ''
        * {
          font-family: 'monospace';
          font-weight: normal;
          font-size: 16px;
          min-width: 0;
          min-height: 0;
          border: none;
          border-radius: 0;
        }

        .modules-left,
        .modules-middle,
        .modules-right {
          background-color: ${colors.base00};
          border-bottom: 2px solid ${colors.base01};
        }

        window#waybar {
          opacity: 0.98;
          background-color: ${colors.base00};
          border-bottom: 2px solid ${colors.base01};
        }

        #workspaces button {
          padding: 0 18px;
          color: ${colors.base04};
        }

        #workspaces button.active {
          color: ${colors.base05};
          background-color: ${colors.base01}; 
        }

        #workspaces button.urgent {
          color: #ff5555;
          background-color: ${colors.base00};
        }

        #pulseaudio,
        #bluetooth,
        #network,
        #clock,
        #tray,
        #cpu {
          margin: 0 6px;
          padding: 0 12px;
          color: ${colors.base05};
          transition-duration: 100ms;
          transition-property: background-color, color, opacity, transform;
          transition-timing-function: ease-in-out;
        }

        #tray {
          margin: 6px 12px;
          padding: 6px 12px;
          border-radius: 4px;
          background-color: ${colors.base01};
        }

        #pulseaudio:hover,
        #bluetooth:hover,
        #network:hover,
        #cpu:hover {
          background-color: ${colors.base01};
        }

        #custom-logo {
          font-size: 18px;
          color: ${colors.base05};
        }

        #custom-separator {
          color: ${colors.base02};
        }
      '';
    };
  };
  systemd = {
    user = {
      services = {
        hyprpaper = {
          Unit = {
            After = [
              "graphical-session.target"
            ];
            PartOf = [
              "graphical-session.target"
            ];
          };
        };
      };
    };
  };
}
