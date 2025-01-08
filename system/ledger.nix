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
      ledger = {
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
      inherit (system) ledger;
    in
    mkIf ledger.enable {
      environment = {
        systemPackages = attrValues {
          inherit (pkgs) ledger-live-desktop;
        };
      };
      hardware = {
        ledger = {
          inherit (ledger) enable;
        };
      };
    };
}
