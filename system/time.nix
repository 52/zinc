{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf types;
in
{
  options = {
    system = {
      time = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        timeZone = mkOption {
          type = types.str;
          default = "Europe/Berlin";
        };
      };
    };
  };
  config =
    let
      inherit (config) system;
      inherit (system) time;
    in
    mkIf time.enable {
      time = {
        inherit (time) timeZone;
      };
    };
}
