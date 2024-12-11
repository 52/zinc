{ config, ... }:
let
  inherit (config) home-style;
in
{
  programs = {
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 48;
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-center = [ "custom/logo" ];
          modules-right = [
            "network"
            "custom/separator"
            "clock"
          ];
          "hyprland/workspaces" = {
            all-outputs = true;
            on-click = "activate";
          };
          "network" = {
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ipaddr} ";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = "Disconnected";
            "format-alt" = "{ifname}: {ipaddr}/{cidr}";
            "tooltip" = false;
          };
          "clock" = {
            "interval" = 10;
            "format" = "{:%H:%M - %d/%m/%y}";
            "tooltip" = false;
          };
          "custom/separator" = {
            "format" = "/";
            "interval" = "once";
            "tooltip" = false;
          };
          "custom/logo" = {
            "format" = "❆";
            "interval" = "once";
            "tooltip" = false;
          };
        };
      };
      style = ''
        * {
            font-size: 16px;
            font-weight: normal;
            font-family: 'monospace';
            min-width: 0;
            min-height: 0;
            border: none;
            border-radius: 0;
        }

        .modules-left,
        .modules-middle,
        .modules-right {
            background-color: ${home-style.colors.base01};
        }

        window#waybar {
            background-color: ${home-style.colors.base01};
        }

        #workspaces button {
            color: ${home-style.colors.base04};
            padding: 0 18px;
        }

        #workspaces button.active {
            color: ${home-style.colors.base03};
            background-color: ${home-style.colors.base02}; 
        }

        #workspaces button.urgent {
            color: #ff5555;
            background-color: ${home-style.colors.base01};
        }

        #network,
        #clock {
            color: ${home-style.colors.base03};
            margin: 0 12px;
        }

        #custom-logo,
        #custom-separator {
            color: ${home-style.colors.base04};
        }
      '';
    };
  };
}
