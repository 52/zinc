{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  inherit (builtins) attrValues;
in
{
  imports = attrValues {
    inherit (inputs.nix-gaming.nixosModules)
      pipewireLowLatency
      platformOptimizations
      ;
  };
  options = {
    system = {
      steam = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        members = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };
    };
  };
  config =
    let
      inherit (config) system;
      inherit (system) steam;
    in
    mkIf steam.enable {
      services = {
        pipewire = {
          lowLatency = {
            enable = true;
          };
        };
      };
      programs = {
        steam = {
          inherit (steam) enable;
          platformOptimizations = {
            enable = true;
          };
        };
        gamemode = {
          inherit (steam) enable;
          settings = {
            general = {
              renice = 10;
              softrealtime = "on";
              inhibit_screensaver = 1;
            };
            custom = {
              start = "${pkgs.libnotify}/bin/notify-send 'Gamemode started!'";
              end = "${pkgs.libnotify}/bin/notify-send 'Gamemode ended!'";
            };
          };
        };
      };
      users = {
        groups = {
          gamemode = {
            inherit (steam) members;
          };
        };
      };
    };
}
