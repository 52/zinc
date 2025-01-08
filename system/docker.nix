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
      docker = {
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
      inherit (builtins) attrValues;
      inherit (config) system;
      inherit (system) docker;
    in
    mkIf docker.enable {
      environment = {
        systemPackages = attrValues {
          inherit (pkgs) kubectl;
        };
      };
      virtualisation = {
        docker = {
          enable = true;
          autoPrune = {
            enable = true;
          };
        };
      };
      users = {
        groups = {
          docker = {
            inherit (docker) members;
          };
        };
      };
    };
}
