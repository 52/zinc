{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    system = {
      spotify = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };
  };
  config =
    let
      inherit (builtins) attrValues;
      inherit (config) system;
      inherit (system) spotify;
    in
    mkIf spotify.enable {
      environment = {
        systemPackages = attrValues {
          inherit (pkgs) spotify;
        };
      };
    };
}
