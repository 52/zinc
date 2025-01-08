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
    system = {
      hyprland = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };
  };
  config =
    let
      inherit (builtins) attrValues attrNames;
      inherit (lib) optionalAttrs filterAttrs;
      inherit (config) system;
      inherit (system) hyprland firefox;
    in
    mkIf hyprland.enable {
      environment = {
        systemPackages = attrValues {
          inherit (pkgs) wl-clipboard;
        };
        sessionVariables =
          {
            NIXOS_OZONE_WL = "1";
            WLR_NO_HARDWARE_CURSORS = "1";
            XDG_SESSION_TYPE = "wayland";
            XDG_SESSION_DESKTOP = "Hyprland";
            XDG_CURRENT_DESKTOP = "Hyprland";
          }
          // optionalAttrs firefox.enable {
            MOZ_ENABLE_WAYLAND = "1";
            MOZ_WEBRENDER = "1";
          };
      };
      programs = {
        hyprland = {
          inherit (hyprland) enable;
        };
      };
      users = {
        groups = {
          video = {
            members = attrNames (filterAttrs (_: u: u.isNormalUser or false) config.users.users);
          };
        };
      };
    };
}
