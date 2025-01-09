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
      inherit (lib) filterAttrs;
      inherit (config) system;
      inherit (system) hyprland;
    in
    mkIf hyprland.enable {
      environment = {
        systemPackages = attrValues {
          inherit (pkgs) wl-clipboard;
        };
      };
      programs = {
        hyprland = {
          inherit (hyprland) enable;
          withUWSM = true;
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
